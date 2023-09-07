defmodule ElixirConfAfricaWeb.UserRegistrationLive do
  use ElixirConfAfricaWeb, :live_view

  alias ElixirConfAfrica.Users
  alias ElixirConfAfrica.Users.User

  def render(assigns) do
    ~H"""
    <div class="flex justify-between w-[100%">
      <div class="w-[40%] signupbackground h-[100vh] flex pt-24 flex-col gap-16  px-12">
        <%!-- <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
              Sign in
            </.link> --%>

        <img src="/images/logo.svg" alt="logo" class="w-[158px] h-[28px]" />
        <p class="text-[36px] w-[176px] leading-[54px] font-bold text-white">
          Welcome
        </p>
        <div class="flex flex-col gap-8">
          <p class=" text-[14px] leading-[21px] text-white">
            Dive deep into Elixir through interactive workshops led by
            experienced mentors, providing practical experience and enhancing
            your understanding of the language.
          </p>
          <p class="bg-[#AD3989] h-[4px] w-[75px]" />
        </div>
      </div>
      <div class="w-[60%] h-[100vh] flex flex-col gap-8 py-2 px-16 bg-[#FFFFFF]">
        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/log_in?_action=registered"}
          method="post"
        >
          <div class="flex flex-col gap-1">
            <p class="text-[#333333] text-[20px] font-bold leading-[30px]">
              Register
            </p>
            <div class="flex text-[#666666] items-center gap-1">
              <p>Already have an account?</p>
              <.link navigate={~p"/users/log_in"} class="underline text-[#AD3989]">
                Login
              </.link>
            </div>
          </div>
          <.error :if={@check_errors}>
            Oops, something went wrong! Please check the errors below.
          </.error>

          <div class="flex justify-between w-[100%]">
            <div class="w-[45%]  flex flex-col gap-2">
              <p class="text-[#666666] text-[14px] leading-[21px]">
                First Name
              </p>
              <.input field={@form[:first_name]} type="text" required />
            </div>
            <div class="w-[45%]  flex flex-col gap-2">
              <p class="text-[#666666] text-[14px] leading-[21px]">
                Last Name
              </p>
              <.input field={@form[:last_name]} type="text" required />
            </div>
          </div>
          <div class="w-[100%]  flex flex-col gap-2">
            <p class="text-[#666666] text-[14px] leading-[21px]">
              Email Address
            </p>
            <.input field={@form[:email]} type="email" required />
          </div>
          <div class="w-[100%]  flex flex-col gap-2">
            <p class="text-[#666666] text-[14px] leading-[21px]">
              Password
            </p>

            <.input field={@form[:password]} type="password" required />
          </div>

          <div class="w-[100%]  flex flex-col gap-2">
            <p class="text-[#666666] text-[14px] leading-[21px]">
              Country
            </p>

            <.input field={@form[:country]} type="text" required />
          </div>

          <p class="text-[#666666] text-[14px] leading-[21px]">
            By continuing past this page, you agree to the
            <span class="text-[#AD3989] font-semibold"> Terms of use </span>
            and understand that information will be used as described in our
            <span class="text-[#AD3989] font-semibold"> Privacy Policy </span>
          </p>

          <:actions>
            <div class="flex justify-end w-[100%]">
              <button
                phx-disable-with="Creating account..."
                class="flex items-center px-4 py-3 text-white rounded-[4px] justify-center bg-[#AD3989]"
              >
                Register
              </button>
            </div>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Users.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Users.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Users.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Users.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Users.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
