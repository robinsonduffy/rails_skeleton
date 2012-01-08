module ApplicationHelper
  def title
    @base_title = "Rails Skeleton"
    if @title.nil?
      @base_title
    else
      "#{@title} | #{@base_title}"
    end
  end
end
