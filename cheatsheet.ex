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

#### Enumerables and Pipelines

# Enumerables (lists, maps, ranges, etc.)
Enum.map([1, 2, 3], fn x -> x * 2 end)
Enum.reduce([1, 2, 3], 0, fn x, acc -> x + acc end)

# Pipelines
[1, 2, 3]
|> Enum.map(&(&1 * 2))
|> Enum.reduce(&(&1 + &2))

#### Enum Functions

# all?/1, all?/2
Enum.all?([1, 2, 3], fn x -> x > 0 end)  # true

# any?/1, any?/2
Enum.any?([1, 2, 3], fn x -> x > 2 end)  # true

# at/2, at/3
Enum.at([1, 2, 3], 1)  # 2

# chunk_every/2, chunk_every/3, chunk_every/4
Enum.chunk_every([1, 2, 3, 4, 5, 6], 2)  # [[1, 2], [3, 4], [5, 6]]

# chunk_by/2
Enum.chunk_by([1, 2, 3, 4, 5, 6], fn x -> rem(x, 2) end)  # [[1], [2], [3], [4], [5], [6]]

# concat/1, concat/2
Enum.concat([[1, 2], [3, 4]])  # [1, 2, 3, 4]

# count/1, count/2
Enum.count([1, 2, 3])  # 3

# dedup/1, dedup_by/2
Enum.dedup([1, 2, 2, 3])  # [1, 2, 3]

# drop/2
Enum.drop([1, 2, 3], 2)  # [3]

# drop_while/2
Enum.drop_while([1, 2, 3], fn x -> x < 3 end)  # [3]

# each/2
Enum.each([1, 2, 3], fn x -> IO.puts(x) end)

# empty?/1
Enum.empty?([])  # true

# fetch/2
Enum.fetch([1, 2, 3], 1)  # {:ok, 2}

# fetch!/2
Enum.fetch!([1, 2, 3], 1)  # 2

# filter/2
Enum.filter([1, 2, 3], fn x -> x > 1 end)  # [2, 3]

# find/2, find/3
Enum.find([1, 2, 3], fn x -> x > 2 end)  # 3

# find_index/2
Enum.find_index([1, 2, 3], fn x -> x == 2 end)  # 1

# find_value/2, find_value/3
Enum.find_value([1, 2, 3], fn x -> x == 2 end)  # 2

# flat_map/2
Enum.flat_map([1, 2, 3], fn x -> [x, x * 2] end)  # [1, 2, 2, 4, 3, 6]

# flatten/1
Enum.flatten([1, [2, [3, 4], 5], 6])  # [1, 2, 3, 4, 5, 6]

# group_by/2, group_by/3
Enum.group_by([1, 2, 3, 4], fn x -> rem(x, 2) end)  # %{0 => [2, 4], 1 => [1, 3]}

# in?/2
Enum.in?([1, 2, 3], 2)  # true

# into/2, into/3
Enum.into([1, 2, 3], [])  # [1, 2, 3]

# join/1, join/2
Enum.join([1, 2, 3], ", ")  # "1, 2, 3"

# map/2
Enum.map([1, 2, 3], fn x -> x * 2 end)  # [2, 4, 6]

# max/1, max/2
Enum.max([1, 2, 3])  # 3

# max_by/2, max_by/3
Enum.max_by([1, 2, 3], fn x -> -x end)  # 1

# member?/2
Enum.member?([1, 2, 3], 2)  # true

# min/1, min/2
Enum.min([1, 2, 3])  # 1

# min_by/2, min_by/3
Enum.min_by([1, 2, 3], fn x -> -x end)  # 3

# partition/2
Enum.partition([1, 2, 3], fn x -> x > 1 end)  # {[2, 3], [1]}

# random/1
Enum.random([1, 2, 3])  # 1 or 2 or 3

# reduce/2, reduce/3
Enum.reduce([1, 2, 3], 0, fn x, acc -> x + acc end)  # 6

# reduce_while/3
Enum.reduce_while([1, 2, 3], 0, fn x, acc -> if x < 3, do: {:cont, acc + x}, else: {:halt, acc} end)  # 3

# reject/2
Enum.reject([1, 2, 3], fn x -> x > 1 end)  # [1]

# reverse/1, reverse/2
Enum.reverse([1, 2, 3])  # [3, 2, 1]

# scan/2, scan/3
Enum.scan([1, 2, 3], 0, fn x, acc -> x + acc end)  # [1, 3, 6]

 shuffle/1
Enum.shuffle([1, 2, 3])  # [2, 3, 1]

# slice/2, slice/3
Enum.slice([1, 2, 3, 4, 5], 1..3)  # [2, 3, 4]
Enum.slice([1, 2, 3, 4, 5], 1, 3)  # [2, 3, 4]

# sort/1, sort/2
Enum.sort([3, 1, 2])  # [1, 2, 3]
Enum.sort([3, 1, 2], fn x, y -> x > y end)  # [3, 2, 1]

# split/2
Enum.split([1, 2, 3, 4, 5], 3)  # {[1, 2, 3], [4, 5]}

# split_while/2
Enum.split_while([1, 2, 3, 4, 5], fn x -> x < 3 end)  # {[1, 2], [3, 4, 5]}

# take/2
Enum.take([1, 2, 3], 2)  # [1, 2]

# take_every/2
Enum.take_every([1, 2, 3, 4, 5], 2)  # [1, 3, 5]

# take_while/2
Enum.take_while([1, 2, 3, 4, 5], fn x -> x < 3 end)  # [1, 2]

# uniq/1, uniq/2
Enum.uniq([1, 2, 2, 3])  # [1, 2, 3]
Enum.uniq([1, 2, 2, 3], fn x -> rem(x, 2) end)  # [1, 2]

#### Agent

# Agent (simple state-holding processes)
{:ok, agent} = Agent.start_link(fn -> %{} end)
Agent.update(agent, &Map.put(&1, :key, "value"))
Agent.get(agent, &(&1))

#### Task

# Task (asynchronous computations)
task = Task.async(fn -> 1 + 2 end)
Task.await(task)  # {:ok, 3}

#### Imports, Aliases, and Requires

# Importing functions from a module
import Enum, only: [map: 2, reduce: 3]

# Aliasing a module
alias MyApp.SomeModule

# Requiring a module (for macros)
require Logger

# Using another module's functionality
use ExUnit.Case

# Create a new empty queue
queue = :queue.new()

# Add elements to the queue
queue = :queue.in(1, queue)
queue = :queue.in(2, queue)

# Get and remove the first element
{{:value, first_element}, queue} = :queue.out(queue)

# Check the first element without removing it
{:value, first_element} = :queue.peek(queue)

# Check if the queue is empty
is_empty = :queue.is_empty(queue)

IO.inspect({first_element, is_empty})

# Create a new empty tree
tree = :gb_trees.empty()

# Insert elements with priorities
tree = :gb_trees.enter(2, "low priority", tree)
tree = :gb_trees.enter(1, "high priority", tree)

# Find and remove the element with the highest priority
{{priority, element}, tree} = :gb_trees.take_smallest(tree)

IO.inspect({priority, element})




