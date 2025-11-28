# frozen_string_literal: true

module Jekyll
  module GuidedContent
    module Commands
      class InitCourse < Jekyll::Command
        class << self
          def init_with_program(prog)
            prog.command(:'init-course') do |c|
              c.syntax 'init-course [options]'
              c.description 'Initialize a new course structure'
              
              c.option 'title', '--title TITLE', 'Course title (will prompt if not provided)'
              c.option 'description', '--description DESC', 'Course description (will prompt if not provided)'
              
              c.action do |args, options|
                Jekyll::GuidedContent::Commands::InitCourse.process(args, options)
              end
            end
          end
          
          def process(args, options)
            require 'yaml'
            require 'fileutils'
            
            # Get course details
            course_title = options['title']
            course_description = options['description']
            
            # Prompt for course details if not provided
            unless course_title
              print "Enter Course Title: "
              course_title = $stdin.gets.chomp
              course_title = "My New Course" if course_title.empty?
            end
            
            unless course_description
              print "Enter Course Description: "
              course_description = $stdin.gets.chomp
              course_description = "A structured course built with Jekyll Guided Content" if course_description.empty?
            end
            
            # Define paths
            project_root = Dir.pwd
            data_dir = File.join(project_root, '_data')
            lessons_dir = File.join(project_root, 'lessons')
            agent_config_dir = File.join(project_root, '_agent_config')
            course_yml_path = File.join(data_dir, 'course.yml')
            sample_lesson_path = File.join(lessons_dir, 'sample-lesson')
            sample_lesson_file = File.join(sample_lesson_path, 'index.md')
            
            # Find template source (in gem's templates directory)
            # This will work both for gem installation and local development
            template_source = find_template('initial-lesson.md')
            unless template_source
              Jekyll.logger.error "Error: Template file 'initial-lesson.md' not found"
              raise "Template file not found"
            end
            
            # Find LESSON_PROMPT.md (in gem root or project root)
            lesson_prompt_source = find_lesson_prompt(project_root)
            
            # Create directories
            FileUtils.mkdir_p(data_dir)
            FileUtils.mkdir_p(sample_lesson_path)
            FileUtils.mkdir_p(agent_config_dir)
            
            # Create course.yml
            course_data = {
              'title' => course_title,
              'description' => course_description,
              'lessons' => [
                {
                  'path' => 'lessons/sample-lesson',
                  'title' => 'Sample Lesson',
                  'description' => 'An example lesson to get you started',
                  'order' => 1
                }
              ]
            }
            
            File.write(course_yml_path, course_data.to_yaml)
            Jekyll.logger.info "Created #{course_yml_path}"
            
            # Copy the lesson template
            FileUtils.cp(template_source, sample_lesson_file)
            Jekyll.logger.info "Created #{sample_lesson_file} (from template file)"
            
            # Copy LESSON_PROMPT.md to _agent_config directory
            if lesson_prompt_source && File.exist?(lesson_prompt_source)
              lesson_prompt_dest = File.join(agent_config_dir, 'LESSON_PROMPT.md')
              FileUtils.cp(lesson_prompt_source, lesson_prompt_dest)
              Jekyll.logger.info "Copied LESSON_PROMPT.md to #{lesson_prompt_dest}"
            else
              Jekyll.logger.warn "Warning: LESSON_PROMPT.md not found, skipping copy"
            end
            
            # Create index.md with course layout
            index_file = File.join(project_root, 'index.md')
            index_content = <<~MARKDOWN
              ---
              layout: course
              ---

              # Welcome to #{course_title}!

              #{course_description}

              Select a lesson from the cards below to get started!
            MARKDOWN
            
            File.write(index_file, index_content)
            Jekyll.logger.info "Created #{index_file}"
            
            Jekyll.logger.info ""
            Jekyll.logger.info "Course initialization complete!"
            Jekyll.logger.info "Run 'bundle exec jekyll serve' to verify your new course."
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
          
          # Find LESSON_PROMPT.md file
          def find_lesson_prompt(project_root)
            # Try project root first
            project_prompt = File.join(project_root, 'LESSON_PROMPT.md')
            return project_prompt if File.exist?(project_prompt)
            
            # Try gem root (3 levels up from commands directory)
            # lib/jekyll-guided-content/commands/ -> lib/ -> gem root
            gem_root = File.expand_path(
              File.join(File.dirname(__FILE__), '..', '..', '..')
            )
            gem_prompt = File.join(gem_root, 'LESSON_PROMPT.md')
            return gem_prompt if File.exist?(gem_prompt)
            
            nil
          end
        end
      end
    end
  end
end
