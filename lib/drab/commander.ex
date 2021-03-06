defmodule Drab.Commander do
  @moduledoc """
  Drab Commander is a module to keep event handlers.

  All the Drab functions (callbacks, event handlers) are placed in the module called `Commander`. Think about 
  it as a controller for the live pages. Commanders should be placed in `web/commanders` directory. Commander must
  have a corresponding controller.

      defmodule DrabExample.PageCommander do
        use Drab.Commander

        def click_button_handler(socket, dom_sender) do
          ...
        end
      end

  Remember the difference: `controller` renders the page while `commander` works on the live page.

  ## Event handler functions

  The event handler function receives two parameters:
  * `socket` - a websocket used to communicate back to the page by `Drab.Query` functions
  * `dom_sender` - a map contains information of the object which sent the event; `dom_sender` map keys are binary strings

  The `dom_sender` map:

      %{
        "id"    => "sender object ID attribute",
        "name"  => "sender object 'name' attribute",
        "class" => "sender object 'class' attribute",
        "text"  => "sender node 'text'",
        "html"  => "sender node 'html', result of running .html() on the node",
        "val"   => "sender object value",
        "data"  => "a map with sender object 'data-xxxx' attributes, where 'xxxx' are the keys",
        "drab_id" => "internal"
      }

  ## Callbacks 

  There is currently one callback, `:onload`. It must be specified as the option of `use` macro:

      defmodule DrabExample.PageCommander do
        use Drab.Commander, onload: :page_loaded

        def page_loaded(socket) do
          ...
        end
      end

  This callback launches when the client browser connects to the server.

  ## Generate the Commander

  There is a mix task (`Mix.Tasks.Drab.Gen.Commander`) to generate skeleton of commander:

      mix drab.gen.commander Name

  See also `Drab.Controller`
  """

  defmacro __using__(options) do
    quote do
      import Drab.Query
      import Drab.Call
      
      Module.put_attribute(__MODULE__, :__drab_opts__, unquote(options))

      unless Module.defines?(__MODULE__, {:__drab__, 0}) do
        def __drab__() do
          opts = Enum.into(@__drab_opts__, %{commander: __MODULE__})
          Map.merge(%Drab.Config{}, opts) 
        end
      end
    end
  end

end
