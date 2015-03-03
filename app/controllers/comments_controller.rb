class CommentsController < ApplicationController
  
  def index
  @comments = @commentable.comments
  @comment = Comment.new
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.update_attributes(commenter_id:  current_user.id , commenter: current_user.email)
    if @comment.save
      flash[:notice] = "Successfully created comment."
      redirect_to :back
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @commentable = find_commentable
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy
    redirect_to :back
  end

private

def find_commentable
   params.each do |name, value|
    if name =~ /(.+)_id$/
      return $1.classify.constantize.find(value)
    end
  end
  nil
end
  def comment_params
    params.require(:comment).permit(:body ,:comenter)
  end
end