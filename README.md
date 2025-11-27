# Jekyll Guided Content

A Jekyll theme for creating course and lesson content with step-by-step guided navigation, focus mode, and synchronized table of contents.

## Features

- **Course Structure**: Course index page with lesson cards and navigation
- **Lesson Pages**: Individual lesson pages with step-by-step content organization
- **Focus Mode**: Utility bar with numbered step navigation and focus mode
- **Table of Contents**: Dynamic TOC synchronized with focus state
- **Pandoc Integration**: Support for advanced Markdown via Pandoc converter
- **Custom Liquid Tags**: `{% level %}` and `{% showme %}` tags for structured content

## Installation

Add this line to your Jekyll site's `Gemfile`:

```ruby
gem "jekyll-guided-content"
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install jekyll-guided-content
```

## Usage

### 1. Configure Your Site

In your `_config.yml`:

```yaml
theme: jekyll-guided-content
```

### 2. Create Course Index

Create `index.md`:

```yaml
---
layout: course
title: My Course
description: Learn something new
---

Welcome to my course!
```

### 4. Create Lessons

Create lessons in `lessons/[name]/index.md`:

```yaml
---
layout: lesson-layout
title: Introduction
description: Getting started
---

{% level subtitle="Getting Started" %}
## Step 1: Introduction

Content here...
{% endlevel %}
```

### 5. Build and Serve

```bash
bundle exec jekyll serve
```

## Custom Liquid Tags

### `{% level %}` Tag

Creates a step container with optional subtitle:

```liquid
{% level subtitle="Quick Start" %}
## Step 1: Getting Started

Content here...
{% endlevel %}
```

### `{% showme %}` Tag

Creates expandable content sections:

```liquid
{% showme "Click to reveal" %}
Hidden content here...
{% endshowme %}
```

## Focus Mode

Focus mode allows users to focus on one step at a time:

- Click "Focus" button in utility bar to enable
- Click numbered buttons to navigate between steps
- Only the focused step is visible
- TOC highlights the active step

## Configuration

### Course Configuration (Optional)

```yaml
course:
  lessons_dir: "lessons"           # Directory for lessons (default: "lessons")
```

### Pandoc Configuration (Optional)

```yaml
pandoc:
  enabled: true                    # Enable Pandoc converter
  extensions: []                   # Pandoc extensions to use
```

**Note**: Pandoc must be installed separately if using the Pandoc converter.

## Dependencies

- Jekyll (>= 3.8, < 5.0)
- Paru (>= 0.3.0) - Ruby wrapper for Pandoc

### External Resources (CDN)

- Bulma CSS (0.9.4)
- Tocbot - JavaScript library for TOC generation
- Highlight.js - Syntax highlighting

## Development

After checking out the repo, run:

```bash
bundle install
```

To install this gem onto your local machine, run:

```bash
bundle exec rake install
```

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).

