# Cover style — {NEWSLETTER_NAME}

<!--
The fixed visual identity for every cover. Maintenance rules live in
.cervantes/engine/MEMORY-SCHEMA.md. The STYLE block stays fixed word for word;
only the per-issue SUBJECT changes. The author may swap the block once for a
stronger look — after that it stays fixed: consistency beats the exact choice.
-->

## Fixed style block (paste verbatim in every prompt)

> {MEDIUM}, {MOOD} mood, color palette of {PALETTE}, {COMPOSITION}, {TEXTURE}.
> {TEXT_ON_IMAGE}.

<!-- {TEXT_ON_IMAGE} defaults to "No text on the image". Only when the author wants
text does it name exactly which text, and only then does "loose text or letters"
leave the exclusions below. -->

## Format

- **Aspect ratio:** {ASPECT_RATIO}   <!-- e.g. 16:9 header (Substack 1200×600) + 1:1 social -->

## Hard exclusions (negative prompt)

{EXCLUSIONS}
<!-- plus always: glossy 3D render, generic stock photo, busy backgrounds, logos/watermarks, and loose text or letters (unless the author asked for text above) -->

## Reference image (style anchor)

{REFERENCE}
<!-- Path or URL of the anchor image. Priority: (1) author's reference handed at
onboarding; (2) the first shipped cover once it exists — save it here when it
ships. Use it alongside the prompt: "same style, light, and stroke as this". -->
