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
            
            # Configure _config.yml (update or create)
            config_file = File.join(project_root, '_config.yml')
            update_config_file(config_file)
            
            # Update Gemfile to remove minima and ensure jekyll-guided-content is included
            gemfile_path = File.join(project_root, 'Gemfile')
            update_gemfile(gemfile_path) if File.exist?(gemfile_path)
            
            # Update assets/css/main.scss to use the theme's styles
            # This fixes the issue where jekyll new creates a local main.scss that overrides the theme
            css_dir = File.join(project_root, 'assets', 'css')
            FileUtils.mkdir_p(css_dir)
            main_scss_path = File.join(css_dir, 'main.scss')
            
            # Only overwrite if it looks like the default minima one (imports "minima" or "base")
            # or if we want to enforce our theme styles
            update_main_scss(main_scss_path)

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
          
          # Update _config.yml to include theme and plugin configuration
          def update_config_file(config_file)
            needs_update = false
            
            if File.exist?(config_file)
              # Read existing config
              config_content = File.read(config_file)
              config_data = YAML.load(config_content) || {}
              
              # Check if theme needs to be set
              unless config_data['theme'] == 'jekyll-guided-content'
                config_data['theme'] = 'jekyll-guided-content'
                needs_update = true
              end
              
              # Check if plugin needs to be added
              config_data['plugins'] ||= []
              unless config_data['plugins'].include?('jekyll-guided-content')
                config_data['plugins'] << 'jekyll-guided-content'
                needs_update = true
              end
              
              if needs_update
                # Write back with YAML formatting
                File.write(config_file, config_data.to_yaml)
                Jekyll.logger.info "Updated #{config_file} with theme and plugin configuration"
              end
            else
              # Create new config file
              config_content = <<~YAML
                # Site configuration
                theme: jekyll-guided-content
                plugins:
                  - jekyll-guided-content
              YAML
              File.write(config_file, config_content)
              Jekyll.logger.info "Created #{config_file} with theme and plugin configuration"
            end
          end
          
          # Update Gemfile to remove minima and ensure jekyll-guided-content is included
          def update_gemfile(gemfile_path)
            return unless File.exist?(gemfile_path)
            
            gemfile_content = File.read(gemfile_path)
            original_content = gemfile_content.dup
            needs_update = false
            
            # Comment out minima theme (we're using jekyll-guided-content instead)
            if gemfile_content.match(/^\s*gem\s+["']minima["']/)
              # Match the full gem line including version if present
              gemfile_content = gemfile_content.gsub(
                /^(\s*)gem\s+["']minima["']([^\n]*)/,
                "\\1# gem \"minima\"\\2  # Commented out - using jekyll-guided-content theme"
              )
              needs_update = true
            end
            
            # Check if jekyll-guided-content already exists (with any path or from RubyGems)
            has_guided_content = gemfile_content.match(/gem\s+["']jekyll-guided-content["']/)
            
            # Only update if jekyll-guided-content is not already present
            unless has_guided_content
              # Find the :jekyll_plugins group and add the gem
              if gemfile_content.match(/group\s+:jekyll_plugins\s+do/)
                # Add after the group declaration (try to find where to insert)
                # Look for existing gems in the group to add after them
                if gemfile_content.match(/(group\s+:jekyll_plugins\s+do\s*\n)(\s+gem\s+[^\n]+\n)*/)
                  # Insert after the last gem in the group
                  gemfile_content = gemfile_content.sub(
                    /(group\s+:jekyll_plugins\s+do\s*\n(?:\s+gem\s+[^\n]+\n)*)/,
                    "\\1  gem \"jekyll-guided-content\"\n"
                  )
                else
                  # Just add after the group declaration
                  gemfile_content = gemfile_content.sub(
                    /(group\s+:jekyll_plugins\s+do\s*\n)/,
                    "\\1  gem \"jekyll-guided-content\"\n"
                  )
                end
                needs_update = true
              else
                # Create the group if it doesn't exist
                gemfile_content += "\n\ngroup :jekyll_plugins do\n  gem \"jekyll-guided-content\"\nend\n"
                needs_update = true
              end
            end
            
            if needs_update && gemfile_content != original_content
              File.write(gemfile_path, gemfile_content)
              Jekyll.logger.info "Updated #{gemfile_path} - commented out minima, ensured jekyll-guided-content is included"
            end
          end
          
          # Update assets/css/main.scss to import guided-content styles
          def update_main_scss(scss_path)
            # Content that imports the theme's SCSS
            new_content = <<~SCSS
              ---
              ---
              /* stylelint-disable */
              // ========================================
              //   Bulma Convention-Based Custom Styles (Sass)
              //   ========================================
              //   
              //   This stylesheet uses Bulma Sass variables for consistency
              //   and maintainability. Variables are defined based on Bulma 0.9.4
              //   ========================================

              // Import the consolidated guided content styles
              @import "guided-content";
            SCSS
            
            if File.exist?(scss_path)
              content = File.read(scss_path)
              # If it imports base or minima, we should replace it
              if content.include?('@import "base"') || content.include?('@import "minima"')
                File.write(scss_path, new_content)
                Jekyll.logger.info "Updated #{scss_path} to use theme styles"
              elsif !content.include?('@import "guided-content"')
                # If it doesn't import guided-content, warn the user
                Jekyll.logger.warn "Warning: #{scss_path} exists but doesn't import 'guided-content'. You may need to update it manually."
              end
            else
              File.write(scss_path, new_content)
              Jekyll.logger.info "Created #{scss_path}"
            end
          end
        end
      end
    end
  end
end
