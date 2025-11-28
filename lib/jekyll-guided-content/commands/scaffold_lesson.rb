# frozen_string_literal: true

module Jekyll
  module GuidedContent
    module Commands
      class ScaffoldLesson < Jekyll::Command
        class << self
          def init_with_program(prog)
            prog.command(:'scaffold-lesson') do |c|
              c.syntax 'scaffold-lesson <lesson-slug> [title] [description]'
              c.description 'Scaffold a new lesson with a basic 3-step template'
              
              c.action do |args, options|
                Jekyll::GuidedContent::Commands::ScaffoldLesson.process(args, options)
              end
            end
          end
          
          def process(args, options)
            require 'yaml'
            require 'fileutils'
            
            # Get command line arguments
            lesson_slug = args[0]
            title = args[1]
            description = args[2]
            
            # Validate input
            if lesson_slug.nil? || lesson_slug.empty?
              Jekyll.logger.error "Error: Lesson slug is required"
              Jekyll.logger.error "Usage: bundle exec jekyll scaffold-lesson <lesson-slug> [title] [description]"
              Jekyll.logger.error "Example: bundle exec jekyll scaffold-lesson advanced-topics 'Advanced Topics' 'Learn advanced Jekyll features'"
              raise "Lesson slug is required"
            end
            
            # Generate title from slug if not provided
            title ||= lesson_slug.split('-').map(&:capitalize).join(' ')
            
            # Default description if not provided
            description ||= "Learn about #{title.downcase}"
            
            # Paths
            project_root = Dir.pwd
            data_file = File.join(project_root, '_data', 'course.yml')
            lesson_path = "lessons/#{lesson_slug}"
            lesson_dir = File.join(project_root, lesson_path)
            lesson_file = File.join(lesson_dir, 'index.md')
            
            # Check if lesson already exists
            if File.exist?(lesson_file)
              Jekyll.logger.error "Error: Lesson '#{lesson_slug}' already exists at #{lesson_file}"
              raise "Lesson already exists"
            end
            
            # Read current course data
            unless File.exist?(data_file)
              Jekyll.logger.error "Error: Course data file not found at #{data_file}"
              Jekyll.logger.error "Please create _data/course.yml first (see QUICKSTART.md or run 'jekyll init-course')"
              raise "Course data file not found"
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
            Jekyll.logger.info "Added lesson to #{data_file} (order: #{next_order})"
            
            # Create lesson directory
            FileUtils.mkdir_p(lesson_dir)
            Jekyll.logger.info "Created directory: #{lesson_dir}"
            
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
            Jekyll.logger.info "Created lesson file: #{lesson_file}"
            
            Jekyll.logger.info ""
            Jekyll.logger.info "Lesson '#{title}' created successfully!"
            Jekyll.logger.info ""
            Jekyll.logger.info "Next steps:"
            Jekyll.logger.info "  1. Edit #{lesson_file} to customize the content"
            Jekyll.logger.info "  2. Add more steps or modify existing ones"
            Jekyll.logger.info "  3. Run 'bundle exec jekyll serve' to preview your changes"
          end
        end
      end
    end
  end
end
