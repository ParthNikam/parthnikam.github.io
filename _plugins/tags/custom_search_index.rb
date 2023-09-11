require 'json'

module Jekyll
  class CustomSearchIndex < Generator
    def generate(site)
      search_data = []

      # Add data from posts
      site.posts.docs.each do |post|
        search_data << {
          'title' => post.data['title'],
          'content' => post.content,
          'url' => post.url
        }
      end

      # Add data from PDFs
      pdfs_dir = File.join(site.source, 'pdfs')
      if Dir.exist?(pdfs_dir)
        Dir.chdir(pdfs_dir) do
          Dir.glob('*.md').each do |pdf_md_file|
            pdf_data = YAML.load(File.read(pdf_md_file))
            search_data << {
              'title' => pdf_data['title'], # Assuming you have a 'title' field in PDF YAML front matter
              'content' => pdf_data['content'], # Assuming you have a 'content' field in PDF YAML front matter
              'url' => File.join('/pdfs', pdf_md_file) # URL to the PDF MD file
            }
          end
        end
      end

      # Write search_data to search.json
      File.open(File.join(site.dest, '/search.json'), 'w') do |file|
        file.write(search_data.to_json)
      end
    end
  end
end
