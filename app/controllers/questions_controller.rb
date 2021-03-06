class QuestionsController < ApplicationController
  load_and_authorize_resource :organization
  load_and_authorize_resource :voting, through: :organization
  load_and_authorize_resource :question, through: :voting, except: [:new, :create, :index]

  # GET /questions
  def index
    @questions = @voting.questions
  end

  # GET /questions/1
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to organization_voting_questions_path(@organization, @voting),
                  notice: t('activerecord.successful.messages.created', model: Question.model_name.human).capitalize
    else
      render :new
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to organization_voting_questions_path(@organization, @voting),
                  notice: t('activerecord.successful.messages.updated', model: Question.model_name.human).capitalize
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
    redirect_to organization_voting_questions_path(@organization, @voting),
                notice: t('activerecord.successful.messages.destroyed', model: Question.model_name.human).capitalize
  end

  private

    # Only allow a trusted parameter "white list" through.
    def question_params
      params.require(:question).permit(:voting_id, :title, :description, options_attributes: [:title, :id, :_destroy])
    end
end
