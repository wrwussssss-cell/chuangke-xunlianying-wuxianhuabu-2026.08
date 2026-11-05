---
name: gpt-image2-prompt
description: Use when writing, optimizing, reviewing, or standardizing GPT Image 2 / image generation prompts, including portrait editing, anime characters, product packaging, posters, branding, UI report pages, photography, Chinese narrative visuals, game assets, and social media covers.
---

# GPT Image 2 Prompt Skill

Use this skill when the user asks to create, improve, audit, classify, template, or standardize prompts for GPT Image 2 or similar image generation models.

The goal is to turn vague image ideas into production-ready visual briefs. Do not write short keyword piles. Write clear, structured prompts that specify the task, subject, composition, style, details, text, constraints, and quality checks.

## Core Rule

High-quality GPT Image 2 prompts should read like a brief for an art director, photographer, designer, or production artist.

Every strong prompt should answer:

- What image should be generated.
- What the image is for.
- Who or what the main subject is.
- Where the subject is placed.
- What composition, camera, lighting, color, material, and mood should be used.
- What text must appear, if any.
- What must be preserved.
- What must not appear.
- What counts as a successful result.

## Universal Prompt Structure

```text
Task:
Generate a {image type} about "{theme}" in {aspect ratio}, for {use case}.

Core Image:
The main subject is {subject}, placed at {position}, doing {action/state}. The image should communicate {main idea/emotion/selling point}.

Visual Style:
Use {style}, combined with {reference aesthetic}. The color palette is {main colors}. Lighting is {lighting type}. Materials should emphasize {material qualities}.

Composition and Camera:
Use {camera/lens/viewpoint}. The composition is {composition type}. Foreground includes {foreground}. Midground includes {midground}. Background includes {background}. The visual focus must be clear.

Details:
Preserve {must keep}. Enhance {what to improve}. Add {props/symbols/details}, but keep the image clean and coherent.

Text and Layout:
Include the text "{exact text}" at {text position}. Typography should feel {font mood}. Text must be clear, readable, and naturally integrated.

Avoid:
Do not include {mistake 1}, {mistake 2}, {mistake 3}. Avoid cheap template design, excessive filters, clutter, wrong text, distorted anatomy, subject deformation, and unrelated decoration.
```

## Structured JSON Template

Use JSON-like prompts for complex image tasks such as product design, character sheets, report pages, branding systems, and multi-object layouts.

```json
{
  "type": "image type",
  "theme": {
    "subject": "core theme",
    "mood": "emotional tone",
    "color_palette": "main and supporting colors"
  },
  "composition": {
    "ratio": "4:3 / 16:9 / 9:16 / 1:1",
    "camera": "lens, angle, viewpoint",
    "layout": "subject, text, and background placement"
  },
  "subject": {
    "identity": "who or what the subject is",
    "appearance": "visual traits",
    "action": "pose, action, or state",
    "expression": "expression or attitude"
  },
  "environment": {
    "scene": "location or world",
    "lighting": "lighting style",
    "materials": "texture and material details"
  },
  "text": {
    "title": "exact title text",
    "labels": ["supporting text 1", "supporting text 2"],
    "typography": "font mood and placement"
  },
  "constraints": {
    "must_keep": ["required preserved elements"],
    "avoid": ["forbidden elements", "common mistakes", "style errors"]
  }
}
```

## Portrait Editing

For portrait edits, prioritize identity preservation over beautification.

```text
Create a high-quality portrait aesthetic upgrade based on the uploaded frontal photo.

Strictly preserve:
The person's identity, facial recognizability, core facial structure, age impression, real skin texture, and original temperament.

Allowed improvements:
Facial vitality, skin texture, lighting, contour clarity, feature harmony, and overall photo completion.

Forbidden:
Do not swap the face. Do not turn the person into a generic influencer face. Do not change age, ethnicity, core features, or identity. Do not over-smooth skin. Do not create change by replacing clothes. The person must remain immediately recognizable.
```

Use phrases like:

- Strictly preserve the original identity.
- Do not change the core facial features.
- Preserve real skin texture and age impression.
- Improve only lighting, texture, clarity, and facial vitality.

## Anime Characters

Anime prompts should define character design, not just say "anime girl".

Include:

- Character name, age impression, personality, and theme color.
- Hair color, hairstyle, eye design, face, outfit, accessories, and props.
- Pose, expression, action, and emotional tone.
- Rendering style, line quality, material detail, and background complexity.

Template:

```text
Generate a high-quality anime character design sheet for "{character name}".

The character has {age impression}, {personality}, {hair color and style}, {eye design}, and {signature features}. The outfit is {outfit style}, with {materials, accessories, and symbolic elements}.

The sheet should include a main front-facing illustration, detail callouts, outfit structure, accessories, representative props, and theme colors. Use a clean background with professional Japanese character reference sheet aesthetics.

Avoid low-quality fan art, broken proportions, wrong hands, overly busy backgrounds, inconsistent colors, and generic character design.
```

## Product Packaging

Product and packaging prompts must specify physical plausibility, item count, materials, branding, and production realism.

Template:

```text
Generate a brand merchandise product display for "{brand / character / event}".

Include:
1 main packaging box, {number} individual packages, {number} badges, {number} acrylic keychains, {number} apparel items / mugs / stickers.

Requirements:
All items must look like real manufacturable products. Packaging materials should feel premium. Printing must be clear. Branding, logo, character art, colors, and patterns must be consistent. Product sizes and quantities must be coherent.

Avoid fake app UI style, thick card-stack design, cheap plastic feel, wrong logos, inconsistent item counts, confused materials, and impossible packaging structures.
```

## Posters and Covers

Poster prompts should emphasize theme binding, narrative composition, typography, cinematic lighting, and restraint.

Template:

```text
Generate a collector-grade cinematic poster about "{theme}".

Use {main person/object} as the primary visual silhouette or central structure. Inside or around it, integrate the most recognizable scenes, relationships, symbols, architecture, props, and atmosphere from the theme. The result should feel like a sophisticated narrative composition, not a random collage.

Use cinematic poster design combined with {aesthetic style}. Emphasize realistic physical lighting, spatial depth, volumetric light, light haze, material texture, restrained color contrast, and a clear title area.

Avoid messy collage, cheap fantasy assets, template website design, excessive decoration, unrelated symbols, and generic backgrounds.
```

## Branding and Merchandise

Branding prompts should make the output feel like a complete design proposal, not disconnected mockups.

Include:

- Header banner.
- Main logo and sub logo.
- Character portrait or mascot.
- Product packaging.
- Promotional poster.
- Social profile mockup.
- Merchandise series.
- Consistent colors, motif, typography, and visual system.

Use wording like:

```text
The image should look like a complete brand identity and merchandise design proposal. All objects must share a unified visual system, consistent color palette, clear hierarchy, and realistic manufacturable quality.
```

## UI Report Pages

For visual reports, avoid generic app dashboard styling. Keep the report professional but image-led.

Template:

```text
Create a horizontal 4:3 high-completion "AI Facial Aesthetic Upgrade Report / Before & After".

Layout:
Before on the left, After on the right, with analysis modules in the center or lower area. The design should feel like a professional visual report, not a generic mobile app interface.

Requirements:
Preserve the person's identity. Show the upgrade logic clearly. Use readable titles, metrics, subtle dividers, comparison arrows, and clean visual hierarchy. UI elements must support the portrait and not overpower it.

Avoid thick cards, app component style, dashboard templates, fake data clutter, and report elements that distract from the subject.
```

## Photography

Photography prompts should specify camera, lens, angle, light, skin texture, clothing, and environment.

Template:

```text
Generate a {camera / lens} style portrait photo of {subject} in {scene}.

Camera:
Shot on {device or camera}, {lens focal length}, with {angle / viewpoint}, and {post-processing style}.

Subject:
The person has {facial features}, {skin texture}, {hair}, {outfit}, {expression}, and {pose}. The image should express {temperament}.

Environment and Lighting:
The scene is {environment}. Lighting is {color temperature, direction, intensity}. Emphasize {material, skin, fabric, atmosphere details}.

Avoid over-smoothed skin, fake studio look, wrong clothing, unnatural pose, excessive grain, and plastic skin.
```

## Chinese Narrative Visuals

For Chinese historical, literary, or national-style themes, avoid shallow decorative "Chinese style". Bind every element to the theme.

Template:

```text
Create a collector-grade epic narrative poster based on "{theme / work / character}".

Use the large side-profile silhouette or central outline of {core figure} as the outer structure. Inside it, grow a complete world of iconic scenes, character relationships, symbolic objects, architecture, props, and atmosphere strongly tied to the theme.

Style:
Cinematic poster design combined with Eastern realist aesthetics. Emphasize real physical lighting, silk, stone, wood, paper, porcelain, skin, candlelight, soft atmospheric perspective, and cinematic depth of field.

Avoid cheap ancient-style assets, generic xianxia templates, random palaces and clouds, unrelated symbols, and ordinary collage.
```

## Game Assets

Game asset prompts should define character identity, action, skill effect, visual readability, and in-game use.

Template:

```text
Generate a {game genre} character key visual for "{character name}". The core skill effect is "{skill effect}".

Character:
The character has {visual traits}, wears {outfit / armor / skin theme}, and is performing {combat action}.

Skill Effect:
The skill appears as {energy shape, color, trajectory, particles, symbols}. The effect must strongly match the character theme.

Image:
Use dynamic composition, strong perspective or low angle, clear subject readability, and a background that supports the skill release. The result should feel like a premium gacha game key visual.

Avoid unrelated effects, wrong weapon shape, effects covering the subject, low-quality mobile ad style, and unclear silhouettes.
```

## Social Media Covers

Social media covers need strong memory, clear title, platform ratio, and emotional atmosphere.

Template:

```text
Generate a {platform / use case} cover image about "{theme}" in {aspect ratio}.

The subject is placed at {position}. The background is {background}. The mood is {emotion}. Leave a clear title area and maintain a strong visual focus.

Text:
Main title: "{title}". Subtitle: "{subtitle}". Typography should feel {font style}. Text must be readable and naturally integrated.

Style:
Use {youth playlist cover / graduation poster / low-resolution film photo / old album memory / campus nostalgia / commercial cover} aesthetics.

Avoid text stuffed into all corners, QR codes, obvious commercial logos, template website style, over-polished advertising look, tourist-poster style, and unreadable typography.
```

## Text Rules

GPT Image 2 can handle text better when the text requirement is constrained.

- Keep text short.
- Prioritize one main title.
- Specify exact text content.
- Specify placement and typography mood.
- Avoid dense small text, QR codes, complex tables, and multi-language clutter.
- Ask for clear readable text and no fake characters.

Example:

```text
Place the title "2026 毕业季" at the top center in a handwritten Chinese title style. It must be clear and readable. Add the signature "青春纪念册" at the lower right. Do not include QR codes, commercial logos, gibberish, or meaningless small text.
```

## Negative Constraint Pattern

Group negative constraints by failure type instead of writing a random negative keyword list.

```text
Avoid:
Identity errors: no face swap, no age change, no changed core facial features.
Structure errors: no extra hands, wrong fingers, twisted limbs, impossible object proportions.
Text errors: no typos, gibberish, fake text, unrelated logos.
Style errors: no template website style, cheap advertising look, excessive AI filter.
Content errors: no unrelated elements, wrong colors, wrong trophy shape, wrong outfit.
Quality errors: no low resolution, heavy noise, over-sharpening, over-smoothing, plastic texture.
```

## High-Value Phrases

Use these phrases when appropriate:

- Strictly preserve...
- Do not create change by...
- The result is not a simple collage, but...
- Every element must be strongly tied to the theme.
- It should look like a real manufacturable product.
- Avoid cheap template design.
- Avoid app component style.
- Avoid obvious AI-generated look.
- Foreground, midground, and background should each contain...
- Check item count, scale, color consistency, structural stability, and packaging logic.

## Final Quality Checklist

Before returning a prompt, verify:

- The image type and use case are clear.
- The aspect ratio and orientation are clear.
- The subject, action, and placement are clear.
- The composition, camera, foreground, midground, and background are clear.
- The style, color, material, lighting, and mood are clear.
- Required text is exact, short, and placed deliberately.
- Must-keep elements are specified.
- Forbidden changes and common errors are specified.
- The success criteria are explicit.

One-line standard:

```text
GPT Image 2 prompt = clear task + clear subject + clear composition + clear style + clear details + clear text + clear preservation rules + clear forbidden errors + clear quality standard.
```
