---
layout: lesson-layout
title: Building Courses with Jekyll Guided Content
description: Learn how to create structured, interactive course content using the jekyll-guided-content gem
---

# Building Courses with Jekyll Guided Content

This lesson will teach you how to use the `jekyll-guided-content` gem to create beautiful, structured course content with step-by-step navigation, focus mode, and interactive elements.

{% utility_bar %}

{% level subtitle="Introduction" %}


## Learning Outcomes

By the end of this lesson, you will be able to:
- Install and configure the jekyll-guided-content gem in a Jekyll site
- Create a course structure with metadata and lesson organization
- Build lesson pages with levels, utility bars, and interactive content
- Use custom Liquid tags for structured and collapsible content

**How this works:**
- This lesson is organized into 6 levels that build on each other
- Each level includes instructions, code examples, and verification steps
- Use the utility bar to navigate between levels and focus on one at a time
- Code hints are available in collapsible sections if you need help

**Each level includes:**
- **Goal**: What you'll accomplish
- **Instructions**: Step-by-step guidance
- **Code Hints**: Examples and snippets (use only if needed)
- **Diving Deeper**: Extra explanations for curious minds
- **Check**: Verification steps to ensure everything works

{% endlevel %}

{% level subtitle="Installation and Configuration" %}

**Goal:** Set up the jekyll-guided-content gem in your Jekyll project.

**User Story:** As a course creator, I want to install and configure the jekyll-guided-content gem so that I can build structured course content with interactive features.

---

### What You'll Do

Install the gem, configure Jekyll to use it, and verify the setup works correctly.

### Instructions

- Add the gem to your `Gemfile` in the `:jekyll_plugins` group
- Run `bundle install` to install dependencies
- Add the gem to the `plugins:` array in `_config.yml`
- Test the installation by running `bundle exec jekyll build`

### 💡 Code Hints

Need help with the setup? Check out these snippets:

{% showme "Show Me: Gemfile Configuration" %}
```ruby
group :jekyll_plugins do
  gem "jekyll-guided-content", path: "../jekyll-guided-content"  # For local development
  # Or from RubyGems:
  # gem "jekyll-guided-content"
end
```
{% endshowme %}

{% showme "Show Me: Jekyll Configuration" %}
```yaml
# _config.yml
plugins:
  - jekyll-guided-content
```
{% endshowme %}

### 🔍 Diving Deeper

**Why use a gem instead of copying files?**

- **Maintainability**: Updates to the gem automatically benefit all projects using it
- **Consistency**: All sites using the gem have the same features and behavior
- **Versioning**: You can pin to specific versions or update when ready
- **Sharing**: Easy to share the gem across multiple projects

**How Jekyll plugins work:**

- Plugins in the `plugins:` array are loaded during Jekyll's initialization
- The gem registers custom Liquid tags, converters, and hooks
- Layouts and assets from the gem are automatically available to your site

### ✅ Check

1. The gem is listed in your `Gemfile` under `:jekyll_plugins`
2. You have run `bundle install` successfully
3. The gem is in the `plugins:` array in `_config.yml`
4. `bundle exec jekyll build` completes without errors
5. No "Unknown tag" errors appear in the build output

---

{% endlevel %}

{% level subtitle="Course Structure Setup" %}
**Goal:** Create the course data file and index page to organize your lessons.

**User Story:** As a course creator, I want to define my course structure and metadata so that students can navigate between lessons easily.

---

### What You'll Do

Create `_data/course.yml` to define course metadata and lesson organization, then create the course index page.

### Instructions

**Option 1: Use the init script (Recommended)**
- Run `ruby bin/init_course.rb` from your project root
- Enter your course title and description when prompted
- The script will create `_data/course.yml`, `index.md`, and a sample lesson automatically

**Option 2: Manual setup**
- Create the `_data/` directory if it doesn't exist
- Create `_data/course.yml` with course title, description, and an empty lessons array
- Create `index.md` in the project root with `layout: course`
- Add introductory content to the index page

### 💡 Code Hints

Need help with the course structure? Check out these snippets:

{% showme "Show Me: Using the Init Script" %}
```bash
# From your Jekyll project root
ruby bin/init_course.rb

# The script will prompt you for:
# - Course Title
# - Course Description

# It automatically creates:
# - _data/course.yml (with course metadata)
# - index.md (course index page)
# - lessons/sample-lesson/index.md (full guided-content lesson template)
# - _agent_config/LESSON_PROMPT.md (lesson creation guide)
```
{% endshowme %}

{% showme "Show Me: Course Data File" %}
```yaml
# _data/course.yml
title: My Awesome Course
description: Learn something amazing with this comprehensive course

# Ordered list of lessons
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
{% endshowme %}

{% showme "Show Me: Course Index Page" %}
```markdown
---
layout: course
---

# Welcome to My Awesome Course!

This course will teach you everything you need to know about...

## What You'll Learn

- Key concept 1
- Key concept 2
- Key concept 3

Select a lesson from the cards below to get started!
```
{% endshowme %}

### 🔍 Diving Deeper

**Why use a data file for course structure?**

- **Centralized Management**: All course metadata in one place
- **Easy Reordering**: Change the `order` field to rearrange lessons
- **Flexible Metadata**: Add custom fields (difficulty, duration, etc.) as needed
- **Dynamic Generation**: The course layout automatically reads from this file

**Understanding the course.yml structure:**

- `title` and `description` appear on the course index page
- Each lesson needs a `path` that matches the directory structure
- The `order` field controls the sequence (lower numbers appear first)
- You can override lesson titles/descriptions here or use page front matter

**Helper Scripts:**

The gem includes helper scripts to streamline course creation:

- **`bin/init_course.rb`**: Initializes a new course with all necessary files
  - Creates `_data/course.yml` with your course metadata
  - Creates `index.md` with the course layout
  - Creates a sample lesson (full guided-content template)
  - Copies `LESSON_PROMPT.md` to `_agent_config/` for reference

- **`bin/create_sample_lesson.rb`**: Creates a new lesson with filler content
  - Takes lesson slug, title, and description as parameters
  - Creates the lesson directory and markdown file
  - Generates three levels with sample content (Introduction, Getting Started, Advanced Application)
  - Automatically adds the lesson to `_data/course.yml` with the next order number

**Example usage:**
```bash
# Initialize a new course
ruby bin/init_course.rb

# Create additional lessons with filler content
ruby bin/create_sample_lesson.rb my-lesson "My Lesson" "Description here"
```

### ✅ Check

1. The `_data/course.yml` file exists with course title and description
2. The `lessons:` array is defined (can be empty initially)
3. `index.md` exists with `layout: course` in front matter
4. The course index page displays when you run `bundle exec jekyll serve`
5. Course title and description appear correctly on the index page

---

{% endlevel %}

{% level subtitle="Creating Your First Lesson" %}
**Goal:** Create a lesson page with levels, utility bar, and structured content.

**User Story:** As a course creator, I want to create lesson pages with step-by-step content so that students can learn progressively.

---

### What You'll Do

Create a lesson directory, add the lesson file with proper front matter, and structure content using level tags and the utility bar.

### Instructions

**Option 1: Use the sample lesson script (Quick start with filler content)**
- Run `ruby bin/create_sample_lesson.rb my-first-lesson "My First Lesson" "Description"`
- This creates a lesson with three levels of filler content ready to customize
- The script automatically adds the lesson to `_data/course.yml`

**Option 2: Use the scaffolder script (Basic template)**
- Run `ruby bin/scaffold_lesson.rb my-first-lesson "My First Lesson" "Description"`
- This creates a lesson with a simple 3-level template
- The script automatically adds the lesson to `_data/course.yml`

**Option 3: Manual creation**
- Manually create `lessons/my-first-lesson/index.md`
- Add front matter with `layout: lesson-layout`, `title`, and `description`
- Include `{% raw %}{% utility_bar %} {% endraw %}` after the introduction
- Create at least one level using `{% raw %}{% level subtitle="[Name]" %}{% endraw %}` tags
- Add the lesson to `_data/course.yml`

### 💡 Code Hints

Need help creating a lesson? Check out these snippets:

{% showme "Show Me: Lesson Front Matter" %}
```markdown
---
layout: lesson-layout
title: My First Lesson
description: Learn the basics of building courses
---
```
{% endshowme %}

{% showme "Show Me: Lesson Structure with Levels" %}
```markdown
# My First Lesson

Welcome to your first lesson!

{% raw %}{% utility_bar %}{% endraw %}

{% raw %}{% level subtitle="Getting Started" %}{% endraw %}
## Getting Started

Your content here...

### Key Points

- Point one
- Point two
- Point three
{% raw %}{% endlevel %}{% endraw %}

{% raw %}{% level subtitle="Building On Basics" %}{% endraw %}
## Building On Basics

Continue with more content...
{% raw %}{% endlevel %}{% endraw %}
```
{% endshowme %}

{% showme "Show Me: Adding Lesson to Course Data" %}
```yaml
# _data/course.yml
lessons:
  - path: lessons/my-first-lesson
    title: My First Lesson
    description: Learn the basics
    order: 1
```
{% endshowme %}

### 🔍 Diving Deeper

**Why use the helper scripts?**

- **Consistency**: Ensures all lessons follow the same structure
- **Time Saving**: Automatically creates directory, file, and updates course.yml
- **Templates**: Provides ready-to-customize templates
  - `create_sample_lesson.rb`: Full 3-level template with filler content (Introduction, Getting Started, Advanced Application)
  - `scaffold_lesson.rb`: Simple 3-level template (Introduction, Getting Started, Wrap up)
- **Error Prevention**: Handles path matching and order numbering automatically
- **Agent Support**: `LESSON_PROMPT.md` in `_agent_config/` provides detailed guidance for AI assistants

**Understanding level tags:**

- The `{% raw %}{% level %}{% endraw %}` tag creates a container for step-by-step content
- The `subtitle` parameter appears in the utility bar navigation
- JavaScript automatically numbers levels (1, 2, 3, etc.) in the utility bar
- Each level should have a clear, focused goal

**Best practices for lessons:**

- Keep levels focused on a single concept or task
- Use clear, descriptive subtitles
- Include examples and code snippets
- Use showme tags for optional or advanced content
- Test your lesson by running the Jekyll server

### ✅ Check

1. The lesson directory exists at `lessons/[lesson-name]/`
2. The lesson file `index.md` has proper front matter
3. The lesson includes `{% utility_bar %}` tag
4. At least one `{% raw %}{% level %}{% endraw %}` tag is present with content
5. The lesson appears in `_data/course.yml` with correct path
6. The lesson displays correctly when viewing the course index
7. Clicking the lesson card navigates to the lesson page

---

{% endlevel %}

{% level subtitle="Advanced Features and Customization" %}
**Goal:** Use showme tags, focus mode, and customize lesson appearance.

**User Story:** As a course creator, I want to add interactive elements and customize the appearance so that my course matches my brand and engages students.

---

### What You'll Do

Add collapsible content with showme tags, understand focus mode functionality, and explore customization options for layouts and styles.

### Instructions

- Add `{% raw %}{% showme "Title" %}{% endraw %}` tags to create collapsible content sections
- Test focus mode by clicking the "Focus" button in the utility bar
- Navigate between levels using the numbered buttons
- Explore customization options in `_layouts/` and `assets/css/`
- Override gem layouts or styles as needed

### 💡 Code Hints

Need help with advanced features? Check out these snippets:

{% showme "Show Me: Using Showme Tags" %}
~~~markdown
{% raw %}{% showme "Click to reveal additional information" %}{% endraw %}
This is hidden content that appears when you click the button.

You can include:
- Lists
- **Bold text**
- *Italic text*
- Code examples

```ruby
def example
  puts "Code works too!"
end
```
{% raw %}{% endshowme %}{% endraw %}
~~~
{% endshowme %}

{% showme "Show Me: Complete Lesson Example" %}
```markdown
---
layout: lesson-layout
title: Complete Example
description: A lesson showing all features
---

# Complete Example

Introduction to the lesson.

{% raw %}{% utility_bar %}{% endraw %}

{% raw %}{% level subtitle="Basics" %}{% endraw %}
## Basics

Core content here.

{% raw %}{% showme "Advanced Details" %}{% endraw %}
Additional information for advanced learners.
{% raw %}{% endshowme %}{% endraw %}
{% raw %}{% endlevel %}{% endraw %}

{% raw %}{% level subtitle="Intermediate" %}{% endraw %}
## Intermediate

Building on the basics.
{% raw %}{% endlevel %}{% endraw %}

{% raw %}{% level subtitle="Advanced" %}{% endraw %}
## Advanced

Advanced concepts here.
{% raw %}{% endlevel %}{% endraw %}
```
{% endshowme %}

{% showme "Show Me: Customizing Styles" %}
```scss
// assets/css/main.scss or _sass/_custom.scss
// Override gem styles
.step.box {
  border-color: #your-brand-color;
}

.utility-bar {
  background-color: #your-brand-color;
}
```
{% endshowme %}

### 🔍 Diving Deeper

**How focus mode works:**

- Click "Focus" in the utility bar to enable focus mode
- Only the currently selected level is visible
- Other levels are hidden but still in the DOM
- The table of contents highlights the active level
- Click numbered buttons to navigate between levels
- Click "Focus" again to show all levels

**Customization strategies:**

- **Layouts**: Copy gem layouts to `_layouts/` and modify them
- **Styles**: Add custom CSS that overrides gem styles
- **Includes**: Override `_includes/` files if needed
- **Data**: Use Jekyll data files for dynamic content
- **Plugins**: Extend functionality with additional plugins

**When to customize:**

- **Branding**: Match your site's color scheme and typography
- **Functionality**: Add features not included in the gem
- **Content Structure**: Modify layouts for specific content types
- **Integration**: Connect with other tools or services

### ✅ Check

1. You have added at least one `{% raw %}{% showme %}{% endraw %}` tag to a lesson
2. The showme content is collapsible (hidden by default, shows on click)
3. Focus mode works (clicking Focus hides/shows levels)
4. Numbered buttons in utility bar navigate between levels
5. Table of contents highlights the active level
6. You understand how to customize layouts and styles
7. Your lesson displays correctly with all features working

---

{% endlevel %}

{% level subtitle="Wrap up"  %}

## Summary

In this lesson, you learned how to:

1. **Install and configure** the jekyll-guided-content gem
2. **Set up course structure** with metadata and organization
3. **Create lesson pages** with levels, utility bars, and structured content
4. **Use advanced features** like showme tags, focus mode, and customization

## Next Steps

- Create your own course using the scaffolder for consistency
- Experiment with different lesson structures and content types
- Customize the layouts and styles to match your brand
- Explore the gem's documentation for additional features
- Build a complete course with multiple lessons

## Resources

- **QUICKSTART.md**: Quick reference guide for getting started
- **LESSON_PROMPT.md**: Detailed guide for creating lessons
- **Gem Documentation**: Check the gem's README for advanced features
- **Example Lessons**: Review existing lessons for inspiration

Happy teaching! 🎓

{% endlevel %}
