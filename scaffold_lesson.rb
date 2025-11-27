#!/usr/bin/env ruby
# frozen_string_literal: true

# Scaffolder script to create a new lesson
# Usage: ruby scaffold_lesson.rb <lesson-slug> [title] [description]
#
# This script:
# 1. Adds a lesson entry to _data/course.yml
# 2. Creates a lesson directory with index.md template
# 3. Generates a 3-step lesson template ready to customize

require 'yaml'
require 'fileutils'

# Get command line arguments
lesson_slug = ARGV[0]
title = ARGV[1]
description = ARGV[2]

# Validate input
if lesson_slug.nil? || lesson_slug.empty?
  puts "Error: Lesson slug is required"
  puts "Usage: ruby scaffold_lesson.rb <lesson-slug> [title] [description]"
  puts "Example: ruby scaffold_lesson.rb advanced-topics 'Advanced Topics' 'Learn advanced features'"
  exit 1
end

# Generate title from slug if not provided
title ||= lesson_slug.split('-').map(&:capitalize).join(' ')

# Default description if not provided
description ||= "Learn about #{title.downcase}"

# Paths
project_root = File.dirname(__FILE__)
data_file = File.join(project_root, '_data', 'course.yml')
lesson_path = "lessons/#{lesson_slug}"
lesson_dir = File.join(project_root, lesson_path)
lesson_file = File.join(lesson_dir, 'index.md')

# Check if lesson already exists
if File.exist?(lesson_file)
  puts "Error: Lesson '#{lesson_slug}' already exists at #{lesson_file}"
  exit 1
end

# Read current course data
unless File.exist?(data_file)
  puts "Error: Course data file not found at #{data_file}"
  puts "Please create _data/course.yml first (see QUICKSTART.md)"
  exit 1
end

course_data = YAML.load_file(data_file)

# Find the next order number
max_order = 0
if course_data['lessons'] && !course_data['lessons'].empty?
  max_order = course_data['lessons'].map { |l| l['order'] || 0 }.max
end
next_order = max_order + 1

# Add new lesson to course data
course_data['lessons'] ||= []
course_data['lessons'] << {
  'path' => lesson_path,
  'title' => title,
  'description' => description,
  'order' => next_order
}

# Write updated course data with proper formatting
yaml_output = <<~YAML
# Course metadata and lesson configuration
title: #{course_data['title']}
description: #{course_data['description']}

# Ordered list of lessons
# Each lesson should have:
#   - path: relative path to lesson (e.g., "lessons/introduction")
#   - title: display title (optional, will use page title if not provided)
#   - description: short description for lesson card (optional)
#   - order: display order (optional, defaults to file order)
lessons:
YAML

course_data['lessons'].each do |lesson|
  yaml_output += <<~YAML
  - path: #{lesson['path']}
    title: #{lesson['title']}
    description: #{lesson['description']}
    order: #{lesson['order']}
  
YAML
end

File.write(data_file, yaml_output)
puts "✓ Added lesson to #{data_file} (order: #{next_order})"

# Create lesson directory
FileUtils.mkdir_p(lesson_dir)
puts "✓ Created directory: #{lesson_dir}"

# Create lesson template
lesson_template = <<~TEMPLATE
---
layout: lesson-layout
title: #{title}
description: #{description}
---

# #{title}

#{description}

{% utility_bar %}

{% level subtitle="Step 1: Getting Started" %}
## Step 1: Getting Started

This is the first step of your lesson. Add your content here.

### Key Concepts

- Concept one
- Concept two
- Concept three

{% showme "Click to reveal additional information" %}
This is hidden content that appears when you click the button.

You can add:
- Lists
- **Bold text**
- *Italic text*
- Code examples
{% endshowme %}
{% endlevel %}

{% level subtitle="Step 2: Building on Basics" %}
## Step 2: Building on Basics

This is the second step. Continue building on the concepts from step 1.

### Practice

Try these exercises:

1. Exercise one
2. Exercise two
3. Exercise three
{% endlevel %}

{% level subtitle="Step 3: Advanced Topics" %}
## Step 3: Advanced Topics

This is the third step. Cover more advanced concepts here.

### Summary

In this lesson, you learned:
- Key concept from step 1
- Key concept from step 2
- Key concept from step 3

{% showme "Click for next steps" %}
Here are some next steps to continue learning:

- Read the documentation
- Try building your own project
- Explore related topics
{% endshowme %}
{% endlevel %}
TEMPLATE

# Write lesson file
File.write(lesson_file, lesson_template)
puts "✓ Created lesson file: #{lesson_file}"

puts "\n🎉 Lesson '#{title}' created successfully!"
puts "\nNext steps:"
puts "  1. Edit #{lesson_file} to customize the content"
puts "  2. Add more steps or modify existing ones"
puts "  3. Run 'bundle exec jekyll serve' to preview your changes"

