# -*- coding: utf-8 -*-
require 'test_helper'

class SnippetrTest < ActiveSupport::TestCase
  test "#images" do
    pt = Snippetr.new("http://r.tabelog.com/hokkaido/A0106/A010603/1009661/")
    assert pt.images.any?{ |url| 
      url == "http://image1-3.tabelog.k-img.com/restaurant/images/Rvw/4896/150x150_square_4896741.jpg"
    }
  end

  test "#images return og:image if it has" do    
    pt = Snippetr.new("http://r.gnavi.co.jp/e104700/")
    assert_equal pt.images,["http://r.gnavi.co.jp/e104700/img/e104700t.jpg"]
  end

  test "#images relative path" do 
    pt = Snippetr.new("http://www.zounohana.com/cafe/")
    assert_equal pt.images.first,"http://www.zounohana.com/cafe/images/pct_menu_01.jpg"
  end

  test "#title" do
    pt = Snippetr.new("http://r.gnavi.co.jp/e104700/")
    assert_equal pt.title,"ぐるなび - とん喜"
  end

  test "#description" do 
    pt = Snippetr.new("http://r.gnavi.co.jp/e104700/")
    assert_not_nil pt.description
  end

  test "#addresses" do
    pt = Snippetr.new("http://r.tabelog.com/tokyo/A1304/A130401/13130066/")
    assert_equal pt.addresses[0],"東京都新宿区新宿3-38-1 ルミネエスト7F"
  end

  test "#address" do
    pt = Snippetr.new("http://www.koganecho.net/")
    assert_equal pt.addresses[0],"横浜市中区日ノ出町2-158"
    pt = Snippetr.new("http://r.tabelog.com/kanagawa/A1401/A140104/14001924/")
    assert_equal pt.addresses,["神奈川県横浜市中区海岸通1-1"]
  end
  
  test "#addresse for TAB" do
#    pt = Snippetr.new("http://www.tokyoartbeat.com/event/2011/4567")
#    assert_equal pt.addresses,["東京都港区南青山5-5-3　B1F"]
  end

  test "shift_jis page" do
    pt = Snippetr.new("http://www.jalan.net/yad323922/")
    assert_equal pt.title,"リッチモンドホテル仙台 - じゃらんnet"
  end
end
