# Quick Start Guide

Get up and running with `jekyll-guided-content` in minutes!

## Installation

Add to your Jekyll site's `Gemfile`:

```ruby
group :jekyll_plugins do
  gem "jekyll-guided-content"
  # Or from GitHub (for latest version):
  # gem "jekyll-guided-content", git: "https://github.com/rmccrear/jekyll-guided-content.git", branch: "bulma-v1"
  # Or for local development:
  # gem "jekyll-guided-content", path: "../jekyll-guided-content"
end
```

**Important**: If you created your site with `jekyll new`, the default `Gemfile` includes `gem "minima"`. The `init-course` command will automatically comment this out for you.

Then run:
```bash
bundle install
```

## Configuration

**CRITICAL**: The gem must be configured as both a **theme** (for layouts and assets) AND a **plugin** (for Liquid tags and commands).

Add to your `_config.yml`:

```yaml
theme: jekyll-guided-content
plugins:
  - jekyll-guided-content

# Optional: Configure Pandoc if using markdown conversion
# The gem will use Pandoc via the 'paru' gem if available
```

**Important Notes:**
- `theme:` is required for layouts (`course`, `lesson-layout`) and assets to work
- `plugins:` is required for Liquid tags (`{% level %}`, `{% showme %}`, `{% utility_bar %}`) and Jekyll commands
- Both must be present for the gem to function correctly
- **If you use `bundle exec jekyll init-course`, this configuration is done automatically**

## Project Structure

```
your-site/
├── _data/
│   └── course.yml          # Course metadata and lesson list
├── _layouts/
│   ├── course.html          # Course index layout (from gem)
│   └── lesson-layout.html   # Individual lesson layout (from gem)
├── lessons/
│   ├── introduction/
│   │   └── index.md
│   └── advanced/
│       └── index.md
├── index.md                 # Course index page
└── Gemfile
```

## Quick Start with Commands

The easiest way to get started is using the `init-course` command:

```bash
bundle exec jekyll init-course
```

This will automatically:
- ✅ Configure `_config.yml` with `theme: jekyll-guided-content` and plugin
- ✅ Update `Gemfile` to comment out default themes (like `minima`) and ensure gem is included
- ✅ Fix `assets/css/main.scss` to import theme styles
- ✅ Create `_data/course.yml` with course metadata
- ✅ Create `index.md` with course layout
- ✅ Create a sample lesson to get you started

## Step 1: Create Course Data File

If you prefer manual setup, create `_data/course.yml`:

```yaml
title: Your Course Name
description: A brief description of your course

lessons:
  - path: lessons/introduction
    title: Introduction
    description: Get started with the basics
    order: 1
  
  - path: lessons/advanced
    title: Advanced Topics
    description: Learn advanced concepts
    order: 2
```

## Step 2: Create Course Index

Create `index.md`:

```yaml
---
layout: course
---
```

Add your course introduction content below the front matter.

## Step 3: Create Your First Lesson

### Option A: Use Jekyll Commands (Recommended)

The gem provides Jekyll subcommands for easy course and lesson creation:

**Initialize a new course:**
```bash
bundle exec jekyll init-course
```

**Create a new lesson:**
```bash
bundle exec jekyll scaffold-lesson my-first-lesson "My First Lesson" "Learn the basics"
```

**Create a lesson with filler content:**
```bash
bundle exec jekyll create-sample-lesson my-first-lesson "My First Lesson" "Learn the basics"
```

These commands will:
- ✅ Add the lesson to `_data/course.yml`
- ✅ Create `lessons/my-first-lesson/index.md` with templates
- ✅ Set up proper front matter and structure
- ✅ Automatically configure the correct order

### Option B: Manual Creation

1. Create the lesson directory:
   ```bash
   mkdir -p lessons/my-first-lesson
   ```

2. Create `lessons/my-first-lesson/index.md`:
   ```markdown
   ---
   layout: lesson-layout
   title: My First Lesson
   description: Learn the basics
   ---
   
   # My First Lesson
   
   Welcome to your first lesson!
   
   {% utility_bar %}
   
   {% level subtitle="Step 1: Getting Started" %}
   ## Step 1: Getting Started
   
   Your content here...
   {% endlevel %}
   ```

3. Add to `_data/course.yml`:
   ```yaml
   lessons:
     - path: lessons/my-first-lesson
       title: My First Lesson
       description: Learn the basics
       order: 1
   ```

## Step 4: Run Your Site

```bash
bundle exec jekyll serve
```

Visit `http://localhost:4000` to see your course!

## Key Features

### Utility Bar
Add a sticky navigation bar with step buttons:
```liquid
{% utility_bar %}
```

### Level Tags (Steps)
Organize content into steps:
```liquid
{% level subtitle="Step Title" %}
## Step Content

Your step content here...
{% endlevel %}
```

### Showme Tags (Collapsible Content)
Create expandable content sections:
```liquid
{% showme "Click to reveal" %}
Hidden content that appears when clicked.
{% endshowme %}
```

### Focus Mode
The utility bar provides a "Focus Mode" button that:
- Shows only the currently selected step
- Hides all other steps
- Syncs with the table of contents

## Lesson Template Structure

A typical lesson includes:

```markdown
---
layout: lesson-layout
title: Lesson Title
description: Brief description
---

# Lesson Title

Introduction paragraph.

{% utility_bar %}

{% level subtitle="Step 1: Title" %}
## Step 1: Title

Content for step 1.

{% showme "Additional Info" %}
Hidden content...
{% endshowme %}
{% endlevel %}

{% level subtitle="Step 2: Title" %}
## Step 2: Title

Content for step 2.
{% endlevel %}

{% level subtitle="Step 3: Title" %}
## Step 3: Title

Content for step 3.
{% endlevel %}
```

## Tips

1. **Use Jekyll commands**: Use `bundle exec jekyll init-course`, `scaffold-lesson`, and `create-sample-lesson` for consistency and speed
2. **Configure both theme and plugin**: Remember to set both `theme: jekyll-guided-content` AND add it to `plugins:` in `_config.yml`
3. **Order matters**: Set `order` in `course.yml` to control lesson sequence
4. **Descriptions help**: Add descriptions to lessons for better course cards
5. **Focus mode**: Great for learners who want to focus on one step at a time
6. **Showme tags**: Use for hints, additional info, or optional content

## Next Steps

- Customize layouts in `_layouts/`
- Add custom CSS in `assets/css/`
- Explore the gem's layouts and includes
- Check the full README.md for advanced features

## Troubleshooting

**Lesson not appearing?**
- Check that the path in `course.yml` matches the directory structure
- Ensure `index.md` exists in the lesson directory
- Verify the lesson has proper front matter

**Tags not working?**
- Make sure `jekyll-guided-content` is in both the `theme:` and `plugins:` configuration in `_config.yml`
- Verify both are present: `theme: jekyll-guided-content` AND `plugins: [jekyll-guided-content]`
- Check that you're using the correct tag syntax
- Run `bundle exec jekyll build` to see error messages

**Layouts not found?**
- Ensure `theme: jekyll-guided-content` is set in `_config.yml`
- The gem must be configured as a theme to expose layouts
- Check build output for layout-related warnings

**Styling issues?**
- The gem includes default styles, but you can override them
- Check browser console for CSS conflicts
- Ensure Bulma CSS is loaded (the gem layouts include it)

## Getting Help

- Check the main README.md for detailed documentation
- Review example lessons in the test projects
- Check the gem's source code for tag implementations

Happy teaching! 🎓

