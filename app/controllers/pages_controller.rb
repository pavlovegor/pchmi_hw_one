class PagesController < ApplicationController
  before_action :get_elements, :get_all_elements

  def show
    render template: "pages/#{params[:page]}"
  end

  def complete
    @answers = params[:elements]
    @elements = File.open('files/log_elements.txt'){ |file| file.read }.split('delimiter').first.split("\n")

    File.open('files/log_elements.txt', 'w'){ |file| file.write "" }

    result = NumbersService.check_answers(@elements, @answers)
    procent = result.first
    not_right_answers = result.last

    pp ['procent', procent]

    render template: "pages/result", :locals => { :procent => procent, :not_right_answers => not_right_answers }
  end

  def statistic
    statistic = NumbersService.create_statistic
    File.open('files/log_elements.txt', 'w'){ |file| file.write "" }
    render template: "pages/statistic", :locals => {
      percent_correct_answer: statistic['percent_correct_answer'],
      percent_correct_color: statistic['percent_correct_color'],
      percent_correct_element: statistic['percent_correct_element'],
      percent_correct_number: statistic['percent_correct_number']
    }
  end

  private
    def get_elements
      @elements = NumbersService.generate_elements(3)
      File.open('files/log_elements.txt', 'a'){ |file| file.puts  @elements }
      File.open('files/log_elements.txt', 'a'){ |file| file.puts  "delimiter"}
      @elements
    end

    def get_all_elements
      @all_elements =  NumbersService.generate_all_elements()
    end
end
