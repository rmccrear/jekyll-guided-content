# Theming Guide for jekyll-guided-content

The gem uses **semantic color variables** that allow you to easily create custom color palettes and themes without modifying the gem's source files.

## Quick Start

To create a custom theme, create a file `_sass/_theme.scss` in your Jekyll site:

```scss
// Custom theme colors
$bg-primary: #ffffff;
$accent-primary: #8b5cf6;
$text-primary: #1f2937;
// ... etc
```

The gem will automatically import your `_theme.scss` file before applying default values.

## Semantic Variable Names

All color variables use semantic naming based on their **purpose**, not their color:

### Background Colors
- `$bg-primary` - Main content background
- `$bg-secondary` - Sidebar, step boxes, light panels
- `$bg-tertiary` - Alternative light backgrounds (hover states, details summary)
- `$bg-interactive` - Interactive element backgrounds (hover, active)
- `$bg-inverse` - Dark backgrounds (headings, emphasis)

### Text Colors
- `$text-primary` - Default text color
- `$text-heading` - Headings, emphasis
- `$text-inverse` - Text on dark backgrounds

### Accent Colors
- `$accent-primary` - Primary accent (links, buttons, active states)
- `$accent-hover` - Hover state for accent

### Border Colors
- `$border-subtle` - Subtle borders (details, code blocks)
- `$border-default` - Default borders (dividers, panels)
- `$border-interactive` - Interactive borders (hover states)

### Scrollbar Colors
- `$scrollbar-track` - Scrollbar track background
- `$scrollbar-thumb` - Scrollbar thumb color
- `$scrollbar-thumb-hover` - Scrollbar thumb hover

## Example Themes

The gem includes example theme files you can copy:

### Light Theme (Default)
- File: `_sass/_theme-light.scss`
- Clean, bright interface with blue accents

### Dark Theme
- File: `_sass/_theme-dark.scss`
- Dark backgrounds with high contrast for low-light reading

### Vampire Theme
- File: `_sass/_theme-vampire.scss`
- Deep black with red accents

## Using a Theme

1. **Copy the theme file** to your Jekyll site:
   ```bash
   cp jekyll-guided-content/_sass/_theme-dark.scss _sass/_theme.scss
   ```

2. **Rebuild your site**:
   ```bash
   bundle exec jekyll build
   ```

3. **Customize as needed** - Edit `_sass/_theme.scss` to adjust colors

## Creating Your Own Theme

1. Create `_sass/_theme.scss` in your Jekyll site

2. Override the semantic variables:
   ```scss
   // My Custom Theme
   $bg-primary: #your-color;
   $bg-secondary: #your-color;
   $accent-primary: #your-color;
   // ... etc
   ```

3. You don't need to define all variables - only override the ones you want to change. The gem's defaults will apply to any you don't override.

## Tips

- **Start with an example theme** - Copy `_theme-dark.scss` or `_theme-vampire.scss` and modify
- **Use color contrast checkers** - Ensure text is readable on backgrounds
- **Test in different lighting** - Dark themes are great for low-light, light themes for bright environments
- **Keep semantic meaning** - `$bg-primary` should always be the main background, regardless of color

## Full Variable List

For a complete list of all customizable variables (including typography, spacing, etc.), see `_sass/_variables.scss` in the gem.

