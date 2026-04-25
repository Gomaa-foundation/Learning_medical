# Chapter Metadata Specification

Every chapter `.md` file that goes into a book chat should begin with a YAML
frontmatter block between `---` markers. This is injected automatically by
`inject-metadata.sh` using your `book-profile-template.yaml`.

This file documents every field, its purpose, and the effect it has on distillation.

---

## Full field reference

```yaml
---
# ── Book-level fields (same for every chapter in the book) ──────────────────

book: "Clean Code"
# The full title. Used in the CKD output header.

book_author: "Robert C. Martin"
# Used for attribution and cross-referencing.

book_slug: "clean-code"
# URL-safe identifier for folder naming in knowledge-base/.
# Convention: lowercase, hyphens, no spaces.

domain: "Computer Science"
# The broad academic domain.
# Values: "Computer Science" | "Mathematics" | "Physics" | "Biology" |
#         "Economics" | "History" | "Philosophy" | etc.

subdomain: "Software Engineering"
# The specific sub-field. Used to calibrate vocabulary and depth.
# Examples: "Operating Systems", "Machine Learning", "Network Protocols",
#           "Algorithms and Data Structures", "Compilers"

language: "Python"
# Primary programming language for code examples in distillation output.
# If null, the AI will choose based on context.
# Values: "Python" | "C" | "C++" | "Java" | "JavaScript" | "Rust" | null

# ── Chapter-level fields (specific to this chapter) ─────────────────────────

chapter_number: 3
# Integer. Must match the file's position in the book.

chapter_title: "Functions"
# Exact title as it appears in the book's table of contents.

chapter_part: "Meaningful Names"
# If the book has parts/sections grouping chapters, name it here. Optional.
# Set to null if not applicable.

estimated_read_time_minutes: 45
# Your estimate of how long the raw chapter takes to read.
# Helps the AI suggest which CKD level to target per session.

difficulty: 2
# Your assessment of the chapter's difficulty relative to the rest of the book.
# Scale: 1 (accessible) → 3 (dense/demanding)
# This affects how much scaffolding the AI adds at L2.

# ── Prerequisite and dependency fields ──────────────────────────────────────

prerequisites:
  # Concepts the reader MUST understand before this chapter makes sense.
  # These appear verbatim in the CKD L0 "Prerequisites:" line.
  # The AI does not re-teach these — it references them and moves on.
  - "Variables and scope"
  - "Basic control flow (if/for/while)"
  - "What a function signature is"

chapter_prerequisites:
  # Chapters from THIS book that should be read before this one.
  # Use chapter numbers. The AI uses this to reference prior CKDs in the vault.
  - 1
  - 2

# ── Content guidance fields ─────────────────────────────────────────────────

key_terms:
  # Technical terms that MUST appear in the L1 concept table.
  # If a term is in this list and not in the distillation output, something was missed.
  # List 5–15 terms. More than 15 suggests the chapter scope is too large.
  - "function length"
  - "single responsibility"
  - "side effects"
  - "flag arguments"
  - "output arguments"
  - "command query separation"
  - "DRY principle"

threshold_concepts:
  # Concepts in this chapter that are likely to produce an illusion of understanding.
  # The AI will mark these with 🚧 and suggest a practice exercise.
  # Be honest — these are the concepts you need to actually code, not just read.
  - "side effects"
  - "command query separation"

known_misconceptions:
  # Common wrong beliefs about this chapter's content.
  # The AI will explicitly address these in L2 even if not directly in the source.
  - "Short functions are always better regardless of abstraction level"
  - "Comments compensate for unclear function names"

# ── Book context fields ──────────────────────────────────────────────────────

book_context: >
  This chapter builds on Chapter 2 (Meaningful Names) by applying the same
  principles to functions specifically. It establishes the core argument that
  functions should do one thing and do it well — a principle that recurs
  throughout the book. The refactoring example at the end of the chapter
  (HtmlUtil) is the most important practical demonstration.
# 2–4 sentences max. Used to frame how this chapter fits the broader arc.
# Helps the AI avoid treating the chapter as an isolated document.

# ── Appendices and End Matter (Non-Chapter Segments) ────────────────────

appendices:
  # Formal appendices. Use appendix_id (usually A, B, C) and appendix_title.
  - appendix_id: "A"
    appendix_title: "Linux Command Reference"
    distill: true

end_matter:
  # Reference material like Index or Glossary. 
  # These are listed as simple strings and are truncated by split-chapters.py.
  # They are stamped with distill: false automatically.
  - "Index"
  - "Glossary"
  - "Answer Key"

# ── Context Chapter Special Case (Process 0.5) ──────────────────────────

section_type: "context"
# Used exclusively for chapter-00-context.md.
# Tells the LLM to use prompts/context-distill.md instead of technical distillation.
# Stamped with distill: false by standard injection.

# ── Reader state fields (set by inject-metadata.sh from your questionnaire) ──

reader_expertise_level: "intermediate"
# Values: "novice" | "intermediate" | "advanced"
# Derived from your questionnaire ratings. Controls vocabulary level and
# whether the AI explains prerequisites or references them.

reader_goal: "Understand enough to apply in code review"
# Your stated goal from the questionnaire. The AI prioritises claims relevant to it.

skip_basics_for:
  # Concepts you already know well — the AI skips the basics and jumps to nuance.
  - "basic function syntax"
  - "DRY principle"

session_target_level: "L0+L1"
# Which CKD levels to produce for this session.
# Values: "L0 only" | "L0+L1" | "Full L0-L2"
# Can be overridden per-chapter in the chat.

---
```

---

## Minimal viable frontmatter

If you're creating metadata manually (not via inject-metadata.sh), this is the
minimum that meaningfully improves distillation quality:

```yaml
---
book: "Book Title"
chapter_number: 1
chapter_title: "Chapter Title"
domain: "Computer Science"
subdomain: "Your Subdomain"
prerequisites:
  - "concept one"
  - "concept two"
key_terms:
  - "term one"
  - "term two"
difficulty: 2
reader_expertise_level: "intermediate"
---
```

---

## Design rationale

**Why metadata improves distillation reliability**

Without metadata, the distillation AI must infer everything from the chapter text:
what the domain is, what the reader already knows, which terms are core vs. peripheral,
and how this chapter relates to the rest of the book. This inference is often wrong.

With metadata, the AI operates with injected context instead of guessing:
- `key_terms` prevents important concepts from being dropped during compression
- `prerequisites` stops the AI from re-explaining things you already know
- `threshold_concepts` ensures the 🚧 markers appear reliably, not by chance
- `book_context` prevents the chapter from being treated as an isolated document
- `reader_expertise_level` controls compression depth without a separate instruction each time

The metadata is also a self-documenting learning record — reading your own
`book-profile-template.yaml` after finishing a book gives you a structured
overview of the domain you just mapped.
