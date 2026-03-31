# Accessibility Remediation Plan

Updated: March 30, 2026

## Objective

Bring the public site closer to WCAG 2.1 AA by removing stale legacy content from the public surface, fixing template-level accessibility failures, and replacing high-traffic PDF-first routes with accessible HTML pages.

## Completed in this pass

- Fixed remaining global sidebar button contrast by darkening the inverse button text color.
- Added accessible names to publication icon links and suppressed missing local paper links automatically.
- Replaced the stale `/cv/` iframe page with an HTML CV summary and updated the main navigation to point to `/cv/` instead of a PDF.
- Retired the broken talk map embed and replaced it with an accessible fallback page.
- Retired the legacy `teaching-materials`, blog tag archive, and blog index pages from the generated site.
- Added a root `.htaccess` to return `410 Gone` for legacy blog and archive paths that may still exist on the UCSD host from earlier deploys.
- Excluded `files/html` and `files/_site` from new builds so they do not keep reappearing in the published site.
- Rewrote generic `here` links in the news data to more descriptive link text.
- Restored missing selected-award links on the homepage data.

## Current high-priority document strategy

1. Keep current course and profile information in HTML first.
2. Treat PDFs as secondary downloads, not the primary navigation path.
3. Prefer external publisher or project pages when a local PDF is missing.
4. Remove dead local document links instead of shipping broken `Paper` buttons.

## Remaining manual work

The site still contains a large local PDF corpus under `files/`. That corpus remains the largest conformance risk because PDF tagging, reading order, heading structure, alt text, and document titles need file-by-file remediation.

Priority order:

1. `files/CV.pdf`
2. `files/teaching/ece-157a/ECE_157A_schedule_25.pdf`
3. current course PDFs linked from `files/teaching/`
4. older local paper PDFs under `files/papers/`

## Operating rule going forward

- New public content should ship as HTML first.
- PDF links should be optional supplements, not the only route to important information.
- Legacy template pages and generated archives should stay unpublished unless they are actively maintained.
