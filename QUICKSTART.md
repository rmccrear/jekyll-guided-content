# Quick Start Guide

Get up and running with `jekyll-guided-content` in minutes!

## Installation

Add to your Jekyll site's `Gemfile`:

```ruby
group :jekyll_plugins do
  gem "jekyll-guided-content", path: "../jekyll-guided-content"  # For local development
  # Or from RubyGems:
  # gem "jekyll-guided-content"
end
```

Then run:
```bash
bundle install
```

## Configuration

Add to your `_config.yml`:

```yaml
plugins:
  - jekyll-guided-content

# Optional: Configure Pandoc if using markdown conversion
# The gem will use Pandoc via the 'paru' gem if available
```

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

## Step 1: Create Course Data File

Create `_data/course.yml`:

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

### Option A: Use the Scaffolder (Recommended)

If you have the scaffolder script in your project:

```bash
ruby bin/scaffold_lesson.rb my-first-lesson "My First Lesson" "Learn the basics"
```

This will:
- ✅ Add the lesson to `_data/course.yml`
- ✅ Create `lessons/my-first-lesson/index.md` with a 3-step template
- ✅ Set up proper front matter and structure

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

1. **Use the scaffolder**: It saves time and ensures consistency
2. **Order matters**: Set `order` in `course.yml` to control lesson sequence
3. **Descriptions help**: Add descriptions to lessons for better course cards
4. **Focus mode**: Great for learners who want to focus on one step at a time
5. **Showme tags**: Use for hints, additional info, or optional content

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
- Make sure `jekyll-guided-content` is in the `plugins:` array in `_config.yml`
- Check that you're using the correct tag syntax
- Run `bundle exec jekyll build` to see error messages

**Styling issues?**
- The gem includes default styles, but you can override them
- Check browser console for CSS conflicts
- Ensure Bulma CSS is loaded (the gem layouts include it)

## Getting Help

- Check the main README.md for detailed documentation
- Review example lessons in the test projects
- Check the gem's source code for tag implementations

Happy teaching! 🎓

