class TasksController < ApplicationController
  before_action :set_task, only: [:toggle, :destroy]

  def index
    @tasks = Task.order(created_at: :desc)
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    respond_to do |format|
      if @task.save
        format.turbo_stream
        format.html { redirect_to tasks_path, notice: "Task created" }
      else
        @tasks = Task.order(created_at: :desc)
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    @task.update(completed: !@task.completed)
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: "Task updated" }
      format.turbo_stream
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: "Task removed." }
      format.turbo_stream
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :completed)
  end
end
