# Course Catalog Reviewer

Create new course catalogs and review/update existing ones for tools, technologies, and programming languages. All catalogs follow the standard structure in `docs/course-catalog-reference.md`.

## For New Catalogs

1. **Identify:** Tool/technology name, current version, target audience, delivery mode
2. **Research:** Official docs, certification objectives, industry use cases, differentiating features
3. **Draft:** Follow standard structure — Header → Overview (2 paragraphs) → Objectives (4-6, Bloom's verbs) → Duration → Prerequisites → Outline
4. **Validate:** Run the checklist from `docs/course-catalog-reference.md`

## For Existing Catalogs

1. **Structural Audit:** Compare against standard structure; flag missing/misordered sections
2. **Content Accuracy:** Deprecated features? Missing new features? Correct branding?
3. **Outline Balance:** Even day workload, learning arc (Concepts → Core → Config → Integration → Admin), appropriate granularity
4. **Language & Tone:** Action verbs in objectives/outline, professional tone, grammar
5. **Change Summary:** List sections added/modified/removed with rationale; flag duration changes

## Quick-Start Prompts

**New:** "Create a course catalog for `<Tool>`. Audience: `<who>`. Duration: `<N days>`. Focus: `<topics>`."

**Review:** "Review the attached `<Tool>` catalog. Check structure, accuracy, balance, language. Provide change summary."
