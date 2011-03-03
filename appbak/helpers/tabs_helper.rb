module TabsHelper

	def tabs_for( *options, &block )
		raise ArgumentError, "Missing block" unless block_given?
		raw TabsHelper::TabsRenderer.new( *options, &block ).render
	end

  class TabsRenderer
    def initialize(options={}, &block)
		  @template = eval( 'self', block.binding )
      @options = options
      @tabs = []
    end

    def create(tab_id, tab_text, options={}, &block)
      raise "Block needed for TabsRenderer#CREATE" unless block_given?
      @tabs << [tab_id, tab_text, options, block]
    end

    def render
      p content_tag(:div, (render_tabs.html_safe + render_bodies.html_safe), {:id => :tabs}.merge(@options))
    end

    private #  ---------------------------------------------------------------------------

    def render_tabs
      content_tag(:ul, render_headers.html_safe)
    end

    def render_headers
      @tabs.collect do |tab|
        content_tag(:li, link_to(content_tag(:span, tab[1]), "##{tab[0]}") )
      end.to_s
    end

    def  render_bodies
      @tabs.collect do |tab|
        content_tag(:div, capture(&tab[3]), tab[2].merge(:id => tab[0]))
      end.to_s
    end

    def method_missing(*args, &block)
      @template.send(*args, &block)
    end
  end
end