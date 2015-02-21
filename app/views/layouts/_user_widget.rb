<ul class="nav nav-pills pull-right">
<% if user_signed_in? %>
	<li><%= link_to "sign out", destroy_user_session_path, ::method => :delete %></li>
<% else %>
  <li><%= link_to 'Login', new_user_session_path %></li>
  <li><%= link_to 'sign up', new_user_regestration_path %></li>
<% end %>
</ul>