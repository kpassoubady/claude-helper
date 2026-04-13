# Course Catalog — Standard Structure & Reference

Reference for `commands/course-catalog-reviewer.md`. All catalogs must follow this structure.

---

## Required Sections (in order)

### 1. Header Block

| Element | Description |
|---------|-------------|
| **School Logo** | School logo at top |
| **Course Title** | Format: `Working with <Tool/Technology>` |
| **Tagline** | One-line subtitle summarizing the learning goal |

### 2. Course Overview

Two paragraphs:
- **Paragraph 1 — Audience & Scope:** Who it's for, workflow style, high-level topics
- **Paragraph 2 — Narrative Flow:** Journey from beginning to end, topic progression

Tone: Professional but approachable. Avoid jargon the audience wouldn't know.

### 3. Productivity Objectives

4-6 bullet points starting with "After this course, you will be able to:"

Use action verbs from Bloom's Taxonomy:

| Level | Verbs |
|-------|-------|
| Remember | Explore, Identify, List, Recognize |
| Understand | Explain, Describe, Summarize, Classify |
| Apply | Discover, Utilize, Demonstrate, Implement |
| Analyze | Analyze, Examine, Compare, Differentiate |
| Evaluate | Evaluate, Assess, Justify, Critique |
| Create | Design, Build, Develop, Construct |

### 4. Course Duration

- **1 Day** — Introductory or narrow-scope tools
- **2 Days** — Standard tools with moderate depth (e.g., JIRA, Jenkins)
- **3-5 Days** — Languages/platforms needing hands-on labs (e.g., JavaScript, React)

### 5. Pre-requisites

2-4 bullets + environment/platform note (e.g., "Course taught using JIRA cloud software").

### 6. Course Outline

```
## Day N:
* ### Module Title
  * Topic
  * Topic
    * Sub-topic
```

**Outline rules:**

| Rule | Detail |
|------|--------|
| Day grouping | Day 1 = foundational; later days build toward advanced |
| Modules per day | 3-6 modules |
| Max nesting | 3 levels (Module → Topic → Sub-topic) |
| Learning arc | Concepts → Core → Config → Integration → Admin |
| Granularity | Each topic = ~15-30 min of instruction |
| Phrasing | Action-oriented: "Create a Project", "Generating a report" |

---

## Validation Checklist

- [ ] Title follows `Working with <Tool>` format
- [ ] Overview: exactly two paragraphs (audience/scope + narrative flow)
- [ ] Objectives: varied Bloom's Taxonomy verbs
- [ ] Duration: realistic for outline breadth
- [ ] Pre-requisites: reasonable, clearly stated
- [ ] Outline days: balanced workload
- [ ] Topic hierarchy: max 3 levels
- [ ] No orphan sub-topics (every sub-topic list has 2+ items)
- [ ] Full learning arc: Concepts → Core → Config → Integration → Admin
- [ ] Consistent markdown formatting

---

## Formatting Reference

| Element | Markdown |
|---------|----------|
| School logo | `**![School Logo][image1]**` |
| Course title | `# **Working with <Tool>**` |
| Tagline | `# **Learn the essentials of <Tool>**` |
| Section headings | `#### **Section Name:**` |
| Day headings | `## **Day N:**` |
| Module titles | `* ### **Module Title**` |
| Topics | `  * Topic name` |
| Sub-topics | `    * Sub-topic name` |

---

## Example Reference

The **"Working with JIRA"** catalog:
- Duration: 2 Days
- Day 1: Basic Concepts, Jira Issue, Components, Configuration — foundation
- Day 2: Board, Agile, Dashboard, Reports, Integration, Administration — applied/advanced
- Objectives: 5 items using Explore, Analyze, Explain, Discover, Design
- Pre-requisites: 2 items + environment note
