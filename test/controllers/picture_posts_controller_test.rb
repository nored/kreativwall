require 'test_helper'

class PicturePostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @picture_post = picture_posts(:one)
  end

  test "should get index" do
    get picture_posts_url, as: :json
    assert_response :success
  end

  test "should create picture_post" do
    assert_difference('PicturePost.count') do
      post picture_posts_url, params: { picture_post: { contend: @picture_post.contend, user_id: @picture_post.user_id, wall_id: @picture_post.wall_id } }, as: :json
    end

    assert_response 201
  end

  test "should show picture_post" do
    get picture_post_url(@picture_post), as: :json
    assert_response :success
  end

  test "should update picture_post" do
    patch picture_post_url(@picture_post), params: { picture_post: { contend: @picture_post.contend, user_id: @picture_post.user_id, wall_id: @picture_post.wall_id } }, as: :json
    assert_response 200
  end

  test "should destroy picture_post" do
    assert_difference('PicturePost.count', -1) do
      delete picture_post_url(@picture_post), as: :json
    end

    assert_response 204
  end
end
