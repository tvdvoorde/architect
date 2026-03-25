---
name: public-research
description: "Use when searching for public best practices, industry guidance, non-vendor recommendations, implementation patterns, comparison articles, community guidance, or public research sources. Trigger for requests such as public best practices, public sourced best practices, search the web, public guidance, industry best practices, community recommendations, public recommendations, or research what the public says about a component or service."
---

## Purpose

Use this skill when the task requires public research rather than vendor documentation.
This skill is especially important when architecture documents in this repository need a Public sourced best practices section.

## Primary tool

- Use the brave-search-mcp-server as the default tool for public web research.
- Prefer Brave search results for discovering public guidance, implementation patterns, and community best practices.
- Do extensive research to find the best public sources, not just the top search result.
- When researching, look for concrete recommendations, not just high-level summaries.
- Synthesize the findings into clear, actionable best practices that can be included in architecture documents.

## Use this skill when

- The user asks for public best practices.
- The user asks for public sourced best practices.
- The user asks to search the web for best practices, recommendations, or implementation guidance.
- The task requires non-vendor sources in addition to official documentation.
- The task requires industry or community guidance for a product, service, or component.

## Research rules

- Use public sources to complement vendor documentation, not replace it.
- Prefer reputable public sources such as standards bodies, foundation documentation, major engineering blogs, security guidance, and well-regarded community references.
- Avoid low-quality SEO content, anonymous summaries, or pages without concrete guidance.
- Extract concrete recommendations, not generic marketing statements.
- When multiple public sources disagree, call out the disagreement and use the most defensible recommendation.

## Output expectations

- Summarize public best practices as clear, concrete bullets tied to the relevant component.
- Keep recommendations implementation-oriented.
- Distinguish public-sourced guidance from vendor-recommended guidance.
- When used for architecture documents, feed the results into the exact section heading Public sourced best practices.

## Architecture-specific usage

When drafting architecture documents in this repository:

1. Identify each major component.
2. Use the brave-search-mcp-server to research public best practices for each component separately.
3. Synthesize only the strongest and most relevant public recommendations.
4. Keep the wording specific to the chosen architecture rather than generic.

## Source quality bar

Prefer sources such as:

- Public documentation from reputable organizations and standards bodies (use search to find the original source, not just a summary page).
- Vendor-neutral architecture references
- Established engineering blogs with concrete operational guidance
- Standards and protocol documentation

Avoid sources such as:

- Thin affiliate blogs
- AI-generated summary pages without source transparency
- Generic listicles without technical substance
- Pages that repeat vendor marketing without operational guidance