defmodule Identicon do
  @moduledoc """
    Creates an identicon based off a string value.
  """

  @doc """
    Generates an Identicon image based on the string input.
    Saves the image to the disk with the name of the string input.
  """
  def main(input) do
    input
    |> hash_input
    |> create_struct
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
    Takes a string and converts it into a list of 16 numbers based off binary values

  ## Examples

        iex> Identicon.hash_input("elixir")
        [116, 181, 101, 134, 90, 25, 44, 200, 105, 60, 83, 13, 72, 235, 56, 58]

  """
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
  
  @doc """
    Turns the input into a struct and defines the hex property.
  """
  def create_struct(hex) do
    %Identicon.Image{hex: hex}
  end

  @doc """
    Generates a RGB color value based on the first three values in the hex value of the Identicon.Image struct.
    Adds the RGB to the color property of the existing struct.
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b} }
  end

  @doc """
    Adds a grid value to the struct, using the hex value of the struct 
    to make 25 values, defining the grid.  Adds the index number for each value.
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = 
      Enum.chunk_every(hex, 3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index
    
    %Identicon.Image{image | grid: grid }
  end

  @doc """
    Mirrors the 1st and 2nd value of a list of numbers and adds them in reverse to the end of the list.

  ## Examples

        iex> Identicon.mirror_row([1, 2, 3])
        [1, 2, 3, 2, 1]

  """
  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end

  @doc """
    Run through the tuples within the grid value of the struct and only keep those that the first tuple is divisible by 0.
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({value, _index}) -> 
      rem(value, 2) == 0
    end
    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Generates coordinates based on existing values of the grid property of the struct.
    Adds these values to the pixel_map property of the struct.
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_value, index}) ->
        x_axis = rem(index, 5) * 50
        y_axis = div(index, 5) * 50

        top_left = {x_axis, y_axis}
        bottom_right = {x_axis + 50, y_axis + 50}

        {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
    Draws the identicon based on the color and pixel_map properties of the struct.
  """
  def draw_image(%Identicon.Image{pixel_map: pixel_map, color: color}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  @doc """
    Saves the identicon to the hard disk with the string.
  """
  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

end
