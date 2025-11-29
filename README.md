# Jekyll Guided Content

A Jekyll theme for creating course and lesson content with step-by-step guided navigation, focus mode, and synchronized table of contents.

## Features

- **Course Structure**: Course index page with lesson cards and navigation
- **Lesson Pages**: Individual lesson pages with step-by-step content organization
- **Focus Mode**: Utility bar with numbered step navigation and focus mode
- **Table of Contents**: Dynamic TOC synchronized with focus state
- **Custom Liquid Tags**: `{% level %}` and `{% showme %}` tags for structured content

## Installation

Add this line to your Jekyll site's `Gemfile`:

```ruby
group :jekyll_plugins do
  gem "jekyll-guided-content"
  # Or from GitHub (for latest version):
  # gem "jekyll-guided-content", git: "https://github.com/rmccrear/jekyll-guided-content.git", branch: "bulma-v1"
end
```

**Important**: If you created your site with `jekyll new`, the default `Gemfile` includes `gem "minima"`. The `init-course` command will automatically comment this out for you.

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install jekyll-guided-content
```

## Usage

### Quick Start with Commands

The gem provides Jekyll subcommands for easy setup:

**Initialize a new course** (automatically configures everything):
```bash
bundle exec jekyll init-course
```

This command will:
- Configure `_config.yml` with `theme: jekyll-guided-content` and plugin
- Update `Gemfile` to comment out default themes (like `minima`) and ensure gem is included
- Fix `assets/css/main.scss` to import theme styles
- Create `_data/course.yml` with course metadata
- Create `index.md` with course layout
- Create a sample lesson to get you started
- Create `_agent_config/LESSON_PROMPT.md` with prompts for LLM agents to create lessons

### Manual Setup

#### 1. Configure Your Site

**CRITICAL**: The gem must be configured as both a **theme** (for layouts and assets) AND a **plugin** (for Liquid tags and commands).

In your `_config.yml`:

```yaml
theme: jekyll-guided-content
plugins:
  - jekyll-guided-content
```

**Note**: If you use `bundle exec jekyll init-course`, this configuration is done automatically.

#### 2. Create Course Index

Create `index.md`:

```yaml
---
layout: course
title: My Course
description: Learn something new
---

Welcome to my course!
```

### 3. Create Lessons

Use Jekyll commands to create lessons:

**Create a lesson with basic template:**
```bash
bundle exec jekyll scaffold-lesson my-lesson "My Lesson" "Description"
```

**Create a lesson with filler content:**
```bash
bundle exec jekyll create-sample-lesson my-lesson "My Lesson" "Description"
```

Or manually create lessons in `lessons/[name]/index.md`:

```yaml
---
layout: lesson-layout
title: Introduction
description: Getting started
---

{% level subtitle="Getting Started" %}
## Introduction

Content here...
{% endlevel %}
```

### 4. Build and Serve

```bash
bundle exec jekyll serve
```

## Jekyll Commands

The gem provides several Jekyll subcommands for managing your course:

### `init-course`

Initialize a new course structure. This automatically configures `_config.yml` with the required theme and plugin settings.

```bash
bundle exec jekyll init-course [--title TITLE] [--description DESC]
```

Options:
- `--title TITLE`: Course title (will prompt if not provided)
- `--description DESC`: Course description (will prompt if not provided)

### `scaffold-lesson`

Create a new lesson with a basic 3-step template.

```bash
bundle exec jekyll scaffold-lesson LESSON_DIR "Lesson Title" "Lesson Description"
```

### `create-sample-lesson`

Create a new lesson with filler content for testing.

```bash
bundle exec jekyll create-sample-lesson LESSON_DIR "Lesson Title" "Lesson Description"
```

## LLM Agent Support

The `init-course` command creates an `_agent_config/` directory containing prompts and configuration for LLM agents:

- **`_agent_config/LESSON_PROMPT.md`**: A comprehensive prompt template for creating lessons and levels using the jekyll-guided-content syntax. This file includes:
  - Format guidelines for complete lessons
  - Structure templates for levels
  - Style guidelines for content
  - Examples of different lesson types (planning, challenge, completion)

**For LLM Agents**: After running `init-course` or any of the lesson creation commands, check the `_agent_config/` directory for documentation and prompts to help create course content. The `LESSON_PROMPT.md` file contains detailed instructions on how to structure lessons with the proper Liquid tags, user stories, goals, and verification steps.

## Custom Liquid Tags

### `{% level %}` Tag

Creates a step container with optional subtitle:

```liquid
{% level subtitle="Quick Start" %}
## Getting Started

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

## Dependencies

- Jekyll (>= 3.8, < 5.0)
- Nokogiri (>= 1.15) - HTML parsing and manipulation

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
