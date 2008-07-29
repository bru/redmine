require File.dirname(__FILE__) + '/../../../test_helper'

class Redmine::Plugin::Hook::ManagerTest < Test::Unit::TestCase
  def setup
    @manager =  Redmine::Plugin::Hook::Manager
  end
  
  def teardown
    @manager.clear_listeners
  end
  
  def test_sanity
    assert true
  end
  
  def test_hook_format
    assert_kind_of Hash, @manager::hooks
    @manager::hooks.each do |hook, registrations|
      assert_kind_of Symbol, hook
      assert_kind_of Array, registrations
      assert_equal 0, registrations.length
    end
  end
  
  def test_valid_hook
    assert @manager::valid_hook?(:issue_show)
  end
  
  def test_invalid_hook
    assert_equal false, @manager::valid_hook?(:an_invalid_hook_name)
  end
  
  def test_clear_listeners
    assert_equal 0, @manager::hooks[:issue_show].length
    @manager.add_listener(:issue_show, Proc.new { } )
    @manager.add_listener(:issue_show, Proc.new { } )
    @manager.add_listener(:issue_show, Proc.new { } )
    @manager.add_listener(:issue_show, Proc.new { } )
    assert_equal 4, @manager::hooks[:issue_show].length
    
    @manager.clear_listeners
    assert_equal 0, @manager::hooks[:issue_show].length
  end
  
  def test_add_listener
    assert_equal 0, @manager::hooks[:issue_show].length
    @manager.add_listener(:issue_show, Proc.new { } )
    assert_equal 1, @manager::hooks[:issue_show].length
  end
end

class Redmine::Plugin::Hook::BaseTest < Test::Unit::TestCase
  def test_sanity
    assert true
  end
  
  def test_help_should_be_a_singleton
    assert Redmine::Plugin::Hook::Base::Helper.include?(Singleton)
  end
  
  def test_helper_should_include_actionview_helpers
    [ActionView::Helpers::TagHelper,
     ActionView::Helpers::FormHelper,
     ActionView::Helpers::FormTagHelper,
     ActionView::Helpers::FormOptionsHelper,
     ActionView::Helpers::JavaScriptHelper, 
     ActionView::Helpers::PrototypeHelper,
     ActionView::Helpers::NumberHelper,
     ActionView::Helpers::UrlHelper].each do |helper|
      assert Redmine::Plugin::Hook::Base::Helper.include?(helper), "#{helper} wasn't included."
    end
  end
end