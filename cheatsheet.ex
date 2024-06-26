### Elixir Cheatsheet

#### Variables and Basic Types

# Variables (immutable bindings)
x = 10
y = "Hello"

# Constants (cannot be rebound)
@my_constant "value"

# Basic types
integer = 42
float = 3.14
atom = :ok
string = "Elixir"
boolean = true
list = [1, 2, 3]
tuple = {:ok, "value"}
map = %{key: "value"}

#### Functions and Pattern Matching

# Function definition
defmodule Math do
  def add(a, b), do: a + b
end

# Pattern matching
defmodule MyModule do
  def my_function(%{key: value}), do: "Matched #{value}"
  def my_function(_), do: "No match"
end

#### Control Structures

# Conditional
if true do
  IO.puts("True branch")
else
  IO.puts("False branch")
end

# Case statement
case {1, 2, 3} do
  {1, x, 3} -> IO.puts("Matched with #{x}")
  _ -> IO.puts("No match")
end

# Pattern matching in function heads (guards)
defmodule MyModule do
  def process(:start), do: "Started"
  def process(:stop), do: "Stopped"
  def process(_), do: "Unknown command"
end

# Cond expression
cond do
  2 + 2 == 5 ->
    "This is Orwellian"
  2 * 2 == 3 ->
    "This is newspeak"
  true ->
    "Everything is fine"
end

# With expression
with {:ok, result1} <- {:ok, 1},
     {:ok, result2} <- {:ok, result1 + 2},
     {:ok, result3} <- {:ok, result2 * 3} do
  result3
else
  _ -> {:error, "Something went wrong"}
end

#### Modules and Structs

# Defining modules
defmodule MyModule do
  def my_function, do: "Hello, Elixir!"
end

# Defining structs
defmodule User do
  defstruct name: "John", age: 30
end

# Creating and accessing struct fields
user = %User{name: "Alice"}
IO.puts(user.name)

#### Lists, Tuples, and Maps

# Lists (linked lists)
list = [1, 2, 3]
hd(list)  # Head of the list
tl(list)  # Tail of the list

# Tuples (fixed-size collections)
tuple = {:ok, "value"}
elem(tuple, 1)  # Accessing tuple elements

# Maps (key-value store)
map = %{key: "value"}
map.key  # Accessing map values

#### Enumerables and Pipelines

# Enumerables (lists, maps, ranges, etc.)
Enum.map([1, 2, 3], fn x -> x * 2 end)
Enum.reduce([1, 2, 3], 0, fn x, acc -> x + acc end)

# Pipelines
[1, 2, 3]
|> Enum.map(&(&1 * 2))
|> Enum.reduce(&(&1 + &2))

#### Processes and Concurrency

# Spawn a process
pid = spawn(fn -> IO.puts("Hello, process!") end)

# Sending and receiving messages
send(pid, {:message, "Hello"})
receive do
  {:message, msg} -> IO.puts("Received: #{msg}")
  _ -> IO.puts("No message")
end

#### Anonymous Functions

# Anonymous function
add = fn a, b -> a + b end
add.(2, 3)  # Invoking an anonymous function

#### Error Handling and Supervisors

# Error handling
case File.read("myfile.txt") do
  {:ok, content} -> IO.puts("File content: #{content}")
  {:error, reason} -> IO.puts("Error: #{reason}")
end

# Supervisor and worker processes
defmodule MyApp.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(MyApp.Worker, [])
    ]
    supervise(children, strategy: :one_for_one)
  end
end

#### Documentation and Tests

# Documentation
@doc """
Returns the sum of two numbers.
"""
def add(a, b), do: a + b

# Tests (ExUnit)
defmodule MyModuleTest do
  use ExUnit.Case

  test "addition" do
    assert Math.add(1, 2) == 3
  end
end

### Ecto (Database Interactions)

#### Schema Definition

defmodule MyApp.User do
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :age, :integer
    has_many :posts, MyApp.Post
    timestamps()
  end
end

#### Migrations

defmodule MyApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :age, :integer
      timestamps()
    end
  end
end

#### Post Schema and Migration

defmodule MyApp.Post do
  use Ecto.Schema

  schema "posts" do
    field :title, :string
    field :content, :string
    belongs_to :user, MyApp.User
    timestamps()
  end
end

defmodule MyApp.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :text
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end
  end
end

#### Associations

defmodule MyApp.Post do
  use Ecto.Schema

  schema "posts" do
    field :title, :string
    field :content, :string
    belongs_to :user, MyApp.User
    timestamps()
  end
end

#### Transactions

# Example of transaction usage
Ecto.Multi.new()
|> Ecto.Multi.insert(:user, MyApp.User.changeset(%MyApp.User{}, user_params))
|> Ecto.Multi.insert(:post, MyApp.Post.changeset(%MyApp.Post{user_id: user_id}, post_params))
|> MyApp.Repo.transaction()

#### Queries

# Querying data
query = from u in MyApp.User,
        where: u.age > 18,
        select: u

MyApp.Repo.all(query)

### Phoenix LiveView

#### LiveView Module

defmodule MyAppWeb.CounterLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="counter">
      <p>Count: <%= @count %></p>
      <button phx-click="increment">Increment</button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0)}
  end

  def handle_event("increment", _params, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + 1)}
  end
end

### Phoenix (Web Development)

#### Channels and PubSub

##### Channel Definition

defmodule MyAppWeb.UserChannel do
  use Phoenix.Channel

  def join("user:lobby", _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_message", %{"body" => body}, socket) do
    broadcast socket, "new_message", %{body: body}
    {:noreply, socket}
  end
end

##### PubSub Usage

defmodule MyAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :my_app

  socket "/socket", MyAppWeb.UserSocket

  # PubSub configuration
  pubsub MyApp.PubSub
end

#### UserSocket

defmodule MyAppWeb.UserSocket do
  use Phoenix.Socket

  channel "user:lobby", MyAppWeb.UserChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
