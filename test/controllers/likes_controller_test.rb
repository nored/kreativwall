require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @like = likes(:one)
  end

  test "should get index" do
    get likes_url, as: :json
    assert_response :success
  end

  test "should create like" do
    assert_difference('Like.count') do
      post likes_url, params: { like: { picture_post_id: @like.picture_post_id, text_post_id: @like.text_post_id, user_id: @like.user_id, video_post_id: @like.video_post_id } }, as: :json
    end

    assert_response 201
  end

  test "should show like" do
    get like_url(@like), as: :json
    assert_response :success
  end

  test "should update like" do
    patch like_url(@like), params: { like: { picture_post_id: @like.picture_post_id, text_post_id: @like.text_post_id, user_id: @like.user_id, video_post_id: @like.video_post_id } }, as: :json
    assert_response 200
  end

  test "should destroy like" do
    assert_difference('Like.count', -1) do
      delete like_url(@like), as: :json
    end

    assert_response 204
  end
end
