require 'test_helper'

class TextPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @text_post = text_posts(:one)
  end

  test "should get index" do
    get text_posts_url, as: :json
    assert_response :success
  end

  test "should create text_post" do
    assert_difference('TextPost.count') do
      post text_posts_url, params: { text_post: { contend: @text_post.contend, user_id: @text_post.user_id, wall_id: @text_post.wall_id } }, as: :json
    end

    assert_response 201
  end

  test "should show text_post" do
    get text_post_url(@text_post), as: :json
    assert_response :success
  end

  test "should update text_post" do
    patch text_post_url(@text_post), params: { text_post: { contend: @text_post.contend, user_id: @text_post.user_id, wall_id: @text_post.wall_id } }, as: :json
    assert_response 200
  end

  test "should destroy text_post" do
    assert_difference('TextPost.count', -1) do
      delete text_post_url(@text_post), as: :json
    end

    assert_response 204
  end
end
