<header>
	<nav class="navbar navbar-expand-sm bg-light shadow-sm">
		<div class='container'>
			<a class="navbar-brand mb-0 h1 text-reset" href="{{ url('')}}"><img src='{{url('img/seeklogo-icon.png')}}' style='width:25px;'>
				My Inventory System</a>
			<ul class="navbar-nav">
				<li class='nav-item'>
					<a class='nav-link text-secondary' href='{{ url('create') }}'><i class="bi bi-journal-plus"></i>
					 Create</a>
				</li>

				<li class='nav-item'>
					<a class='nav-link text-secondary' href='{{ url('read') }}'><i class="bi bi-journal"></i>
					 Read</a>
				</li>

				<li class='nav-item'>
					<a class='nav-link text-secondary' href='{{ url('update') }}'><i class="bi bi-journal-text"></i>
					 Update</a>
				</li>

				<li class='nav-item'>
					<a class='nav-link text-secondary' href='{{ url('delete') }}'><i class="bi bi-journal-minus"></i>
					 Delete</a>
				</li>

				<li class='nav-item'>
					<a class='nav-link text-secondary' href='{{ url('about') }}'><i class="bi bi-journal-code"></i> 
					About</a>
				</li>

				<li class='nav-item'>
					{% if user_login %}
						<a class='nav-link text-secondary' href='{{ url('logout') }}'>
						<i class="bi bi-person-fill"></i>
							Logout
						</a>
					{% else %}
						<a class='nav-link text-secondary' href='{{ url('login') }}'>
							<i class="bi bi-person-fill"></i>
							Login
						</a>
					{% endif %}
				</li>
			</ul>
		</div>
	</nav>
</header>


<div class="container">
	{{content()}}
</div>

<footer class='footer text-center bg-light  pt-3' style='box-shadow: 6px 0px 5px 0px rgba(0,0,0,.15)'>
	<small>Copyright © 2023</small>
</footer>
