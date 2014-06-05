module V1
  module Appdata
    class EventsController <  ApplicationController
      before_action :set_event, only:[:show, :update, :destroy, :show_reminders]
      check_authorization
      load_and_authorize_resource :through => :current_user
      
      # GET /events
      # @params
      # n - number of events to return (defaults to 5)
      # s - sort {asc,desc} (defaults to desc)
      # by - sort by {label,time,most} where most=>most reminders (defaults to time)
      def index
        n = 5
        s = 'desc'
        by = 'time'
        
        n = params[:n] if params[:n]
        s = params[:s] if params[:s]
        by = params[:by] if params[:by]
        
        #TODO implement conditional params
        @events = current_user.events
        render json: @events
      end
  	
      # GET /events/:id
      def show
        #@event = Event.find(params[:id])
        #TODO figure out how to gracefully handle when a user tries to grab wrong event id
        if can? :show, @event
          render json: @event
        end
      end
  	
      # POST /events/new
      def create
        logger.debug "HERE"
        @event = current_user.events.build(event_params)
  	
        if @event.save
          render json: @event, status: :created
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end
  	
      # POST /events/1
      def update
        if @event.update(params[:event])
          head :ok
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end
      
  	  # GET /events/:id/delete
      def destroy
        @event.destroy
    
        head :ok
      end
      
      private
      # Use callbacks to share common setup or constraints between actions.
      def set_event
        #@event = Event.find(params[:id])
      end
  
      # Only allow a trusted parameter "white list" through.
      def event_params
        if  ["index", "destroy"].include?(params[:action]) 
          # Workaround when dealing with JSON:
          params.permit(:event) 
        else
          params.require(:event).permit(:name)
        end
      end
      
      #UPCOMING
      # GET /events/reminders
      # GET /events/reminders/:start-:end
      def show_reminders
        if params[:start] && params[:end]
          if params[:start] < params[:end]
            start = params[:start]
            last = params[:end]
          else
            #error start must be less than end 
          end 
        else
          start = 0
          last = 4
        end
        #@event = Event.find(params[:id])
        render json: @event
      end
    
      # GET /events/recent
      def show_recent
        @events = Event.all
        render json: @events
      end
      
      # GET /events/upcoming
      def show_upcoming
        @events = Event.all
        render json: @events
      end
    end
  end
end