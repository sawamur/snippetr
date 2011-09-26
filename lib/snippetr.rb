# -*- coding: utf-8 -*-
require 'uri'
require 'open-uri'
require 'nokogiri'
require 'jcode'

class Snippetr
  def initialize(url)
    @uri = URI.parse(url)
    @doc = Nokogiri::HTML(open(@uri).read)
  end

  def url
    @uri.to_s
  end

  def og_image
    meta = @doc.at('/html/head/meta[@property="og:image"]')
    if meta.nil?
      nil
    else
      meta[:content]
    end
  end

  def images
    og = og_image
    return [og] if og 
    elms = @doc.search("img").select{ |el|
      el[:src] =~ /\.jpe?g/
    }
    elms = elms.select{|el|
      el[:width].to_i > 100 && el[:height].to_i > 100
    }
    urls = elms.map{|el|
      (@uri + el[:src]).to_s
    }
    urls
  end
  
  def title 
    @doc.search("title").inner_html.toutf8
  end
  
  def description 
    meta = @doc.at('/html/head/meta[@name="description"]')
    if meta.nil?
      nil
    else
      meta[:content].toutf8
    end
  end

  def addresses
    $KCODE = 'u'
    body = (@doc/"body").text.toutf8
    body.tr!("０-９","0-9")
    body.tr!("ー","-")
    body.tr!("（）","()")
    body.tr!("、",",")
    #puts body
    addrs = body.scan(/([^\s,()]{2,8}(都|道|府|県)[^\s,()]{1,8}(市|区|町|村).+)/).map{ |m|
      line = m[0]
      line.gsub!(/住所(\s|\n)?/,"")
      line.gsub!(/〒\d{3}-\d{4}　?/,"")
      line.gsub!(/\s+$/,"")
      line.gsub!(/\s?電話:.+$/,"") 
      line
    }
    if addrs.blank?
      addrs = body.scan(/([^\s]+(市|区).{2,8}(町|村).{2,10}\d)/).map{ |m|
        line = m[0]
        line.gsub!(/住所(\s|\n)?/,"")
        line.gsub!(/〒\d{3}-\d{4}　?/,"")
        line.gsub!("[MAP]","")
        line.gsub!(/(TEL|FAX):\d{2,4}-\d{2,4}-\d{2,4}/,"")
        line
      }
    end
    addrs
  end
end
