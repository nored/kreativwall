require 'test_helper'

class VideoPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @video_post = video_posts(:one)
  end

  test "should get index" do
    get video_posts_url, as: :json
    assert_response :success
  end

  test "should create video_post" do
    assert_difference('VideoPost.count') do
      post video_posts_url, params: { video_post: { contend: @video_post.contend, user_id: @video_post.user_id, wall_id: @video_post.wall_id } }, as: :json
    end

    assert_response 201
  end

  test "should show video_post" do
    get video_post_url(@video_post), as: :json
    assert_response :success
  end

  test "should update video_post" do
    patch video_post_url(@video_post), params: { video_post: { contend: @video_post.contend, user_id: @video_post.user_id, wall_id: @video_post.wall_id } }, as: :json
    assert_response 200
  end

  test "should destroy video_post" do
    assert_difference('VideoPost.count', -1) do
      delete video_post_url(@video_post), as: :json
    end

    assert_response 204
  end
end
