#!/usr/bin/env python3
"""
Session log maintenance utility for ai-session-governance.

Implements AGENTS.md / INIT.md §4a as executable behavior:
- Detect triggers:
  1) SESSION_LOG.md exceeds line threshold (default: 400)
  2) Oldest entry is older than max-age-days (default: 30)
- Move archived entries into quarterly files under dev/archive/
- Preserve at least 2 most-recent entries
- Never delete entries; only move
- Keep latest entry (with handoff prompt block) in active SESSION_LOG.md
"""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from datetime import date, datetime, timedelta, timezone
from pathlib import Path
from typing import Dict, List, Sequence, Tuple


ARCHIVE_POINTER = (
    "<!-- Archives: dev/archive/ — entries moved when >400 lines "
    "or oldest entry >30 days -->"
)
ENTRY_HEADING_RE = re.compile(r"^## (\d{4}-\d{2}-\d{2})$", re.MULTILINE)
PROMPT_BLOCK_HEADER = "### Next Session Handoff Prompt (Verbatim)"


@dataclass(frozen=True)
class SessionEntry:
    position: int
    heading_date: date
    text: str


@dataclass
class MaintenanceStats:
    line_count_before: int
    line_count_after: int
    entry_count_before: int
    entry_count_after: int
    archived_count: int
    line_trigger: bool
    date_trigger: bool
    trigger: bool
    oldest_entry_before: str | None
    oldest_entry_after: str | None
    archive_files: List[str]


def utc_today() -> date:
    return datetime.now(timezone.utc).date()


def parse_date_or_today(raw: str | None) -> date:
    if not raw:
        return utc_today()
    return date.fromisoformat(raw)


def split_header_and_entries(text: str) -> Tuple[List[str], List[SessionEntry]]:
    lines = text.splitlines()
    starts = [i for i, line in enumerate(lines) if ENTRY_HEADING_RE.match(line)]
    if not starts:
        return lines, []

    header = lines[: starts[0]]
    entries: List[SessionEntry] = []
    for idx, start in enumerate(starts):
        end = starts[idx + 1] if idx + 1 < len(starts) else len(lines)
        block_lines = lines[start:end]
        match = ENTRY_HEADING_RE.match(block_lines[0])
        if not match:
            continue
        entries.append(
            SessionEntry(
                position=idx,
                heading_date=date.fromisoformat(match.group(1)),
                text="\n".join(block_lines).rstrip("\n"),
            )
        )
    return header, entries


def build_log_text(header_lines: Sequence[str], entries: Sequence[SessionEntry]) -> str:
    parts: List[str] = []
    if header_lines:
        parts.append("\n".join(header_lines).rstrip("\n"))
    for entry in entries:
        parts.append(entry.text.rstrip("\n"))
    built = "\n\n".join(part for part in parts if part != "")
    return built.rstrip() + ("\n" if built else "")


def ensure_archive_pointer(header_lines: Sequence[str]) -> List[str]:
    if any(ARCHIVE_POINTER in line for line in header_lines):
        return list(header_lines)

    out = list(header_lines)
    if not out:
        out = ["# Session Log", ARCHIVE_POINTER]
        return out

    if out[0].strip().startswith("# Session Log"):
        out.insert(1, ARCHIVE_POINTER)
    else:
        out.append(ARCHIVE_POINTER)
    return out


def select_protected_entries(entries: Sequence[SessionEntry], keep: int = 2) -> set[int]:
    # Most-recent first by date, tie-breaker: physically topmost (smaller position).
    ordered = sorted(entries, key=lambda e: (-e.heading_date.toordinal(), e.position))
    protected = {entry.position for entry in ordered[:keep]}
    return protected


def quarter_filename(d: date) -> str:
    quarter = (d.month - 1) // 3 + 1
    return f"SESSION_LOG_{d.year}_Q{quarter}.md"


def append_archives(archive_dir: Path, entries_to_archive: Sequence[SessionEntry]) -> List[str]:
    if not entries_to_archive:
        return []
    archive_dir.mkdir(parents=True, exist_ok=True)
    by_file: Dict[str, List[SessionEntry]] = {}
    for entry in entries_to_archive:
        by_file.setdefault(quarter_filename(entry.heading_date), []).append(entry)

    written: List[str] = []
    for filename, file_entries in by_file.items():
        path = archive_dir / filename
        sorted_entries = sorted(file_entries, key=lambda e: e.position)
        payload = "\n\n".join(entry.text.rstrip("\n") for entry in sorted_entries).rstrip() + "\n"
        if path.exists():
            existing = path.read_text(encoding="utf-8").rstrip()
            if existing:
                path.write_text(existing + "\n\n" + payload, encoding="utf-8")
            else:
                path.write_text(payload, encoding="utf-8")
        else:
            path.write_text(payload, encoding="utf-8")
        written.append(str(path.as_posix()))
    return sorted(written)


def evaluate_triggers(
    log_text: str,
    entries: Sequence[SessionEntry],
    today_utc: date,
    line_threshold: int,
    max_age_days: int,
) -> Tuple[bool, bool]:
    line_trigger = len(log_text.splitlines()) > line_threshold
    if not entries:
        return line_trigger, False
    cutoff = today_utc - timedelta(days=max_age_days)
    oldest = min(entry.heading_date for entry in entries)
    date_trigger = oldest < cutoff
    return line_trigger, date_trigger


def maintain_session_log(
    log_text: str,
    today_utc: date,
    line_threshold: int,
    target_lines: int,
    max_age_days: int,
) -> Tuple[str, List[SessionEntry], List[SessionEntry], MaintenanceStats]:
    header, entries = split_header_and_entries(log_text)
    before_lines = len(log_text.splitlines())
    before_count = len(entries)
    oldest_before = min((e.heading_date for e in entries), default=None)
    line_trigger, date_trigger = evaluate_triggers(
        log_text=log_text,
        entries=entries,
        today_utc=today_utc,
        line_threshold=line_threshold,
        max_age_days=max_age_days,
    )
    if not (line_trigger or date_trigger):
        stats = MaintenanceStats(
            line_count_before=before_lines,
            line_count_after=before_lines,
            entry_count_before=before_count,
            entry_count_after=before_count,
            archived_count=0,
            line_trigger=False,
            date_trigger=False,
            trigger=False,
            oldest_entry_before=oldest_before.isoformat() if oldest_before else None,
            oldest_entry_after=oldest_before.isoformat() if oldest_before else None,
            archive_files=[],
        )
        return log_text, list(entries), [], stats

    protected = select_protected_entries(entries, keep=2)
    cutoff = today_utc - timedelta(days=max_age_days)
    archived_positions: set[int] = set()

    # Date-trigger pass: archive all older-than-cutoff entries except protected.
    if date_trigger:
        for entry in entries:
            if entry.position in protected:
                continue
            if entry.heading_date < cutoff:
                archived_positions.add(entry.position)

    def current_active() -> List[SessionEntry]:
        return [entry for entry in entries if entry.position not in archived_positions]

    # Line-trigger pass: archive oldest removable entries until target.
    if line_trigger:
        while True:
            active = current_active()
            active_text = build_log_text(header, active)
            if len(active_text.splitlines()) <= target_lines:
                break
            removable = [
                entry
                for entry in active
                if entry.position not in protected
            ]
            if not removable:
                break
            oldest = min(
                removable,
                key=lambda e: (e.heading_date.toordinal(), -e.position),
            )
            archived_positions.add(oldest.position)

    archived_entries = [
        entry for entry in entries if entry.position in archived_positions
    ]
    active_entries = [
        entry for entry in entries if entry.position not in archived_positions
    ]
    new_header = ensure_archive_pointer(header) if archived_entries else list(header)
    new_log_text = build_log_text(new_header, active_entries)

    oldest_after = min((e.heading_date for e in active_entries), default=None)
    stats = MaintenanceStats(
        line_count_before=before_lines,
        line_count_after=len(new_log_text.splitlines()),
        entry_count_before=before_count,
        entry_count_after=len(active_entries),
        archived_count=len(archived_entries),
        line_trigger=line_trigger,
        date_trigger=date_trigger,
        trigger=True,
        oldest_entry_before=oldest_before.isoformat() if oldest_before else None,
        oldest_entry_after=oldest_after.isoformat() if oldest_after else None,
        archive_files=[],
    )
    return new_log_text, active_entries, archived_entries, stats


def has_prompt_block(entry_text: str) -> bool:
    return PROMPT_BLOCK_HEADER in entry_text and "```text" in entry_text and "```" in entry_text


def mode_check(args: argparse.Namespace) -> int:
    log_path = Path(args.session_log)
    if not log_path.exists():
        print(f"[check] SESSION_LOG missing: {log_path}")
        return 1
    raw = log_path.read_text(encoding="utf-8")
    _, entries = split_header_and_entries(raw)
    line_trigger, date_trigger = evaluate_triggers(
        log_text=raw,
        entries=entries,
        today_utc=parse_date_or_today(args.today_utc),
        line_threshold=args.line_threshold,
        max_age_days=args.max_age_days,
    )
    trigger = line_trigger or date_trigger
    out = {
        "trigger": trigger,
        "line_trigger": line_trigger,
        "date_trigger": date_trigger,
        "line_count": len(raw.splitlines()),
        "entry_count": len(entries),
    }
    if args.emit_json:
        print(json.dumps(out, ensure_ascii=False))
    else:
        print(f"[check] trigger={trigger} line_trigger={line_trigger} date_trigger={date_trigger}")
        print(f"[check] line_count={out['line_count']} entry_count={out['entry_count']}")
    return 2 if trigger else 0


def mode_apply(args: argparse.Namespace) -> int:
    log_path = Path(args.session_log)
    archive_dir = Path(args.archive_dir)
    if not log_path.exists():
        print(f"[apply] SESSION_LOG missing: {log_path}")
        return 1

    raw = log_path.read_text(encoding="utf-8")
    new_log, active_entries, archived_entries, stats = maintain_session_log(
        log_text=raw,
        today_utc=parse_date_or_today(args.today_utc),
        line_threshold=args.line_threshold,
        target_lines=args.target_lines,
        max_age_days=args.max_age_days,
    )
    if not stats.trigger:
        print("[apply] No trigger. No changes made.")
        return 0

    if archived_entries:
        archive_files = append_archives(archive_dir, archived_entries)
        stats.archive_files = archive_files
        log_path.write_text(new_log, encoding="utf-8")

    latest_has_prompt = has_prompt_block(active_entries[0].text) if active_entries else False
    out = {
        "trigger": stats.trigger,
        "line_trigger": stats.line_trigger,
        "date_trigger": stats.date_trigger,
        "line_count_before": stats.line_count_before,
        "line_count_after": stats.line_count_after,
        "entry_count_before": stats.entry_count_before,
        "entry_count_after": stats.entry_count_after,
        "archived_count": stats.archived_count,
        "oldest_entry_before": stats.oldest_entry_before,
        "oldest_entry_after": stats.oldest_entry_after,
        "archive_files": stats.archive_files,
        "latest_entry_prompt_block_ok": latest_has_prompt,
    }
    if args.emit_json:
        print(json.dumps(out, ensure_ascii=False))
    else:
        print("[apply] Maintenance complete.")
        print(
            "[apply] trigger="
            f"{stats.trigger} line_trigger={stats.line_trigger} date_trigger={stats.date_trigger}"
        )
        print(
            "[apply] lines "
            f"{stats.line_count_before} -> {stats.line_count_after}; "
            f"entries {stats.entry_count_before} -> {stats.entry_count_after}; "
            f"archived={stats.archived_count}"
        )
        if stats.archive_files:
            print("[apply] archive files:")
            for item in stats.archive_files:
                print(f"  - {item}")
        print(f"[apply] latest entry prompt block ok={latest_has_prompt}")
    return 0 if latest_has_prompt else 1


def synth_log(entries: Sequence[Tuple[date, str]], with_pointer: bool = False) -> str:
    header = ["# Session Log"]
    if with_pointer:
        header.append(ARCHIVE_POINTER)
    body: List[str] = []
    for d, payload in entries:
        body.append(
            "\n".join(
                [
                    f"## {d.isoformat()}",
                    f"- **ID:** Sim_{d.strftime('%Y%m%d')}_0000",
                    f"- **Summary:** {payload}",
                    "- **Changed:** AGENTS.md",
                    "- **Done:** simulated",
                    "- **QC:** simulated",
                    "- **Pending:** simulated",
                    "- **Next:** simulated",
                    "- **Risks:** simulated",
                    "",
                    "### Next Session Handoff Prompt (Verbatim)",
                    "",
                    "```text",
                    "Read AGENTS.md first (governance SSOT), then follow its §1 startup sequence:",
                    "dev/SESSION_HANDOFF.md → dev/SESSION_LOG.md → dev/CODEBASE_CONTEXT.md (if exists) → dev/PROJECT_MASTER_SPEC.md (if exists)",
                    "",
                    "Post-startup first action: simulated",
                    "```",
                ]
            )
        )
    return ("\n".join(header) + "\n\n" + "\n\n".join(body)).rstrip() + "\n"


def mode_self_test(args: argparse.Namespace) -> int:
    today = parse_date_or_today(args.today_utc)
    scenarios = [
        {
            "name": "normal_no_trigger",
            "entries": [(today, "new"), (today - timedelta(days=1), "recent")],
            "expect_trigger": False,
            "expect_archived_min": 0,
        },
        {
            "name": "line_trigger_only",
            "entries": [
                (today - timedelta(days=i), "x" * 240)
                for i in range(30)
            ],
            "expect_trigger": True,
            "expect_archived_min": 1,
        },
        {
            "name": "date_trigger_only",
            "entries": [
                (today, "new"),
                (today - timedelta(days=1), "recent"),
                (today - timedelta(days=45), "old"),
            ],
            "expect_trigger": True,
            "expect_archived_min": 1,
        },
        {
            "name": "both_triggers",
            "entries": [
                (today - timedelta(days=i), "z" * 320)
                for i in range(28)
            ]
            + [(today - timedelta(days=70), "very old")],
            "expect_trigger": True,
            "expect_archived_min": 1,
        },
        {
            "name": "retain_two_even_if_old",
            "entries": [
                (today - timedelta(days=50), "old1"),
                (today - timedelta(days=51), "old2"),
            ],
            "expect_trigger": True,
            "expect_archived_min": 0,
        },
    ]

    rows = []
    all_pass = True
    tmp_root = Path("dev/_selftest_work")
    tmp_root.mkdir(parents=True, exist_ok=True)
    for sc in scenarios:
        scenario_dir = tmp_root / sc["name"]
        scenario_dir.mkdir(parents=True, exist_ok=True)
        log_path = scenario_dir / "SESSION_LOG.md"
        archive_dir = scenario_dir / "archive"
        log_path.write_text(synth_log(sc["entries"], with_pointer=False), encoding="utf-8")

        raw_before = log_path.read_text(encoding="utf-8")
        _, entries_before = split_header_and_entries(raw_before)
        line_trigger, date_trigger = evaluate_triggers(
            log_text=raw_before,
            entries=entries_before,
            today_utc=today,
            line_threshold=args.line_threshold,
            max_age_days=args.max_age_days,
        )
        trigger = line_trigger or date_trigger

        apply_args = argparse.Namespace(
            session_log=str(log_path),
            archive_dir=str(archive_dir),
            today_utc=today.isoformat(),
            line_threshold=args.line_threshold,
            target_lines=args.target_lines,
            max_age_days=args.max_age_days,
            emit_json=True,
        )
        rc = mode_apply(apply_args)
        raw_after = log_path.read_text(encoding="utf-8")
        _, entries_after = split_header_and_entries(raw_after)
        oldest_after = min((e.heading_date for e in entries_after), default=None)
        cutoff = today - timedelta(days=args.max_age_days)
        archived_files = list(archive_dir.glob("SESSION_LOG_*_Q*.md"))
        archived_lines = sum(path.read_text(encoding="utf-8").count("\n") for path in archived_files)

        checks = {
            "trigger_expected": trigger == sc["expect_trigger"],
            "retained_min_two": len(entries_after) >= 2,
            "latest_prompt_preserved": has_prompt_block(entries_after[0].text) if entries_after else False,
            "pointer_present_when_archived": (ARCHIVE_POINTER in raw_after)
            if trigger and archived_lines > 0
            else True,
            "line_trim_when_line_trigger": (
                len(raw_after.splitlines()) <= args.target_lines or len(entries_after) <= 2
            )
            if line_trigger
            else True,
            "date_trim_when_date_trigger": (
                oldest_after >= cutoff if oldest_after and len(entries_after) > 2 else True
            )
            if date_trigger
            else True,
            "archived_min": archived_lines >= sc["expect_archived_min"],
            "apply_rc_ok": rc == 0,
        }
        pass_row = all(checks.values())
        all_pass = all_pass and pass_row
        rows.append(
            {
                "scenario": sc["name"],
                "trigger": trigger,
                "line_trigger": line_trigger,
                "date_trigger": date_trigger,
                "entries_before": len(entries_before),
                "entries_after": len(entries_after),
                "lines_before": len(raw_before.splitlines()),
                "lines_after": len(raw_after.splitlines()),
                "archived_files": [str(p.name) for p in archived_files],
                "pass": pass_row,
                "failed_checks": [k for k, v in checks.items() if not v],
            }
        )

    print("MATRIX_QC scenario\tline_trigger\tdate_trigger\tentries_before\tentries_after\tlines_before\tlines_after\tpass\tfailed")
    for row in rows:
        print(
            f"MATRIX_QC {row['scenario']}\t{row['line_trigger']}\t{row['date_trigger']}\t"
            f"{row['entries_before']}\t{row['entries_after']}\t{row['lines_before']}\t"
            f"{row['lines_after']}\t{row['pass']}\t{','.join(row['failed_checks'])}"
        )
    print(f"MATRIX_QC summary: {sum(1 for r in rows if r['pass'])}/{len(rows)} passed")
    return 0 if all_pass else 1


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Maintain dev/SESSION_LOG.md archives per §4a.",
    )
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true", help="Check trigger status only.")
    mode.add_argument("--apply", action="store_true", help="Apply archive maintenance.")
    mode.add_argument("--self-test", action="store_true", help="Run matrix self-test scenarios.")

    parser.add_argument("--session-log", default="dev/SESSION_LOG.md", help="Path to SESSION_LOG.md")
    parser.add_argument("--archive-dir", default="dev/archive", help="Archive directory path")
    parser.add_argument("--today-utc", default=None, help="Override UTC date (YYYY-MM-DD)")
    parser.add_argument("--line-threshold", type=int, default=400, help="Trigger threshold for total lines")
    parser.add_argument("--target-lines", type=int, default=200, help="Post-maintenance target max lines")
    parser.add_argument("--max-age-days", type=int, default=30, help="Archive entries older than this many days")
    parser.add_argument("--emit-json", action="store_true", help="Emit JSON output for check/apply modes")
    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    if args.check:
        return mode_check(args)
    if args.apply:
        return mode_apply(args)
    if args.self_test:
        return mode_self_test(args)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
