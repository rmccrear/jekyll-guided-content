# frozen_string_literal: true

module Jekyll
  module GuidedContent
    module Commands
      class CreateSampleLesson < Jekyll::Command
        class << self
          def init_with_program(prog)
            prog.command(:'create-sample-lesson') do |c|
              c.syntax 'create-sample-lesson <lesson-slug> [title] [description]'
              c.description 'Create a new lesson with filler content template'
              
              c.action do |args, options|
                Jekyll::GuidedContent::Commands::CreateSampleLesson.process(args, options)
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
              Jekyll.logger.error "Usage: bundle exec jekyll create-sample-lesson <lesson-slug> [title] [description]"
              Jekyll.logger.error "Example: bundle exec jekyll create-sample-lesson sample-lesson 'Sample Lesson' 'A sample lesson with filler content'"
              raise "Lesson slug is required"
            end
            
            # Generate title from slug if not provided
            title ||= lesson_slug.split('-').map(&:capitalize).join(' ')
            
            # Default description if not provided
            description ||= "A sample lesson with filler content for #{title.downcase}"
            
            # Paths
            project_root = Dir.pwd
            data_file = File.join(project_root, '_data', 'course.yml')
            lesson_path = "lessons/#{lesson_slug}"
            lesson_dir = File.join(project_root, lesson_path)
            lesson_file = File.join(lesson_dir, 'index.md')
            
            # Find template file (in gem's templates directory)
            template_file = find_template('sample-lesson-with-filler.md')
            unless template_file
              Jekyll.logger.error "Error: Template file 'sample-lesson-with-filler.md' not found"
              raise "Template file not found"
            end
            
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
            
            # Read template file and replace placeholders
            lesson_template = File.read(template_file)
              .gsub('{{TITLE}}', title)
              .gsub('{{DESCRIPTION}}', description)
            
            # Write lesson file
            File.write(lesson_file, lesson_template)
            Jekyll.logger.info "Created lesson file: #{lesson_file}"
            
            Jekyll.logger.info ""
            Jekyll.logger.info "Sample lesson '#{title}' created successfully!"
            Jekyll.logger.info ""
            Jekyll.logger.info "Next steps:"
            Jekyll.logger.info "  1. Edit #{lesson_file} to replace filler content with your actual lesson"
            Jekyll.logger.info "  2. Customize the three levels with your specific content"
            Jekyll.logger.info "  3. Run 'bundle exec jekyll serve' to preview your lesson"
          end
          
          private
          
          # Find template file in gem's templates directory
          def find_template(template_name)
            # Try gem's templates directory first
            # Templates are at lib/jekyll-guided-content/templates/
            # Commands are at lib/jekyll-guided-content/commands/
            gem_templates_dir = File.expand_path(
              File.join(File.dirname(__FILE__), '..', 'templates')
            )
            gem_template_path = File.join(gem_templates_dir, template_name)
            return gem_template_path if File.exist?(gem_template_path)
            
            # Fallback: try in project's bin/templates (for local development)
            project_template_path = File.join(Dir.pwd, 'bin', 'templates', template_name)
            return project_template_path if File.exist?(project_template_path)
            
            nil
          end
        end
      end
    end
  end
end
