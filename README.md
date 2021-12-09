# antonio_soto@yahoo.com

rails new Bitacora2
cd bitacora2
rails g model User  first_name:string last_name:string email_address:string
rails db:migrate
rails g model Blog name:string description:string
rails db:migrate
rails g model Post  title:string content:text user:references blog:references
rails db:migrate
rails g model Message  author:string message:text user:references post:references
rails db:migrate
rails g model Owner  user:references blog:references
rails db:migrate
# blog.rb
class Blog < ApplicationRecord
    has_many :posts

	has_many :owners
	has_many :users, through: :owners

	validates :name, :description, presence: true
end
# message.rb
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :post
end
# owner.rb
class Owner < ApplicationRecord
  belongs_to :user
  belongs_to :blog
end
# post.rb
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :blog
  has_many :messages
end
# user.rb
class User < ApplicationRecord
    has_many :owners
    has_many :blogs, through: :owners
    has_many :messages, dependent: :destroy
    has_many :posts, dependent: :destroy
    validates :first_name, :last_name, presence: true
end 


# Crear 5 Usuarios.
User.create(first_name:"Mario", last_name:"Ruz", email_address:"mruz@admin.com")
User.create(first_name:"Alberto", last_name:"Ruz", email_address:"aruz@admin.com")
User.create(first_name:"Maria", last_name:"Rojas", email_address:"mrojas@admin.com")
User.create(first_name:"Maria", last_name:"Perez", email_address:"mperez@admin.com")
User.create(first_name:"Roberto", last_name:"Perez", email_address:"rperez@admin.com")
# Crear 5 blogs.
Blog.create(name:"Juegos Blog", description:"Para jugadores")
Blog.create(name:"Perro Blog", description:"Para amigos perrunos")
Blog.create(name:"Gato Blog", description:"Para amigos mininos")
Blog.create(name:"Viajes Blog", description:"Para viajeros")
Blog.create(name:"Historia Blog", description:"Amantes de los hechos")
# Haz que los primeros 3 blogs pertenezcan al primer usuario.
Owner.create(user: User.first, blog: Blog.find(3))
Owner.create(user: User.first, blog: Blog.find(2))
Owner.create(user: User.first, blog: Blog.first)
# Haz que el cuarto blog que crea pertenezca al segundo usuario.
Owner.create(user: User.find(2), blog: Blog.find(4))
# Haz que el quinto blog que crea pertenezca al último usuario.
Owner.create(user: User.find(5), blog: Blog.find(5))
# Haz que el tercer usuario sea el propietario de todos los blogs que se crearon.
Blog.all.users<<User.find(3)
Blog.all.each { |blog| Owner.create(user: User.third, blog: blog) }
# Haz que el primer usuario cree tres publicaciones para el blog con id = 2. Recuerde que no debe hacer Publicacion.create(usuario: Usuario.first, blog_id: 2), sino algo como Publicacion.create(usuario: Usuario.first, blog: Blog.find(2)). Repito, nunca se debe hacer referencia a las claves foráneas en Rails.
Post.create(title: "Este Cielo", content: "Acerca del cielo", user: User.first, blog: Blog.find(2))
Post.create(title: "Este Mar", content: "Acerca del mar", user: User.first, blog: Blog.find(2))
Post.create(title: "Este Mundo", content: "Acerca del mundo", user: User.first, blog: Blog.find(2))
# Haz que el segundo usuario cree 5 publicaciones para el último blog.
Post.create(title: "El gigante", content: "Mas grande",  user: User.second, blog: Blog.last)
Post.create(title: "El cielo", content: "Mas cielo",  user: User.second, blog: Blog.last)
Post.create(title: "El sol", content: "Mas sol",  user: User.second, blog: Blog.last)
Post.create(title: "La tierra", content: "Mas tierra",  user: User.second, blog: Blog.last)
Post.create(title: "La fuente", content: "Mas agua",  user: User.second, blog: Blog.last)
# Haz que el tercer usuario cree varias publicaciones en diferentes blogs.
Post.create(title: "El sur", content: "Al sur",  user: User.find(3), blog: Blog.find(2))
Post.create(title: "El norte", content: "Al norte",  user: User.find(3), blog: Blog.last)
# Haz que el tercer usuario cree 2 mensajes para la primera publicación creada y 3 mensajes para la segunda publicación creada.
Message.create(author: "Vacio2", message: "Nada", user: User.third, post: Post.second)
Message.create(author: "Vacio1", message: "Nada", user: User.third, post: Post.second)
Message.create(author: "Vacio", message: "Nada", user: User.third, post: Post.second)
Message.create(author: "Futbol4", message: "jugaremos", user: User.third, post: Post.first)
Message.create(author: "Futbol3", message: "jugaremos", user: User.third, post: Post.first)
# Haz que el cuarto usuario cree 3 mensajes para la última publicación que tu creaste.
Message.create(author: "un sueño2", message: "Recuerdame", user: User.find(4), post: Post.last)
Message.create(author: "un sueño1", message: "Recuerdame", user: User.find(4), post: Post.last)
Message.create(author: "un sueño", message: "Recuerdame", user: User.find(4), post: Post.last)
# Cambie el propietario de la 2 publicación para que sea el último usuario.
Post.second.update(user: User.last)
# Cambie el contenido de la segunda publicación por algo diferente.
Post.find(2).update(content: "Ganamos")
# Obtenga todos los blog que son propiedad del tercer usuario (haz que esto funcione con un simple Usuario.find(3).blogs).
User.find(3).blogs
# Obtenga todas las publicaciones que fueron creadas por el tercer usuario.
Post.find_by(user: User.third)
# Obtenga todos los mensajes escritos por el tercer usuario.
Message.find_by(user: User.third)
# Obtenga todas las publicaciones asociadas al blog con id = 5 y quién dejó cada publicación.
Post.joins(:user, :blog).where(blog: Blog.find(5)).select("*")
# Obtenga todos los mensajes asociados al blog con id = 5, junto con toda la información de los usuarios que dejaron mensajes.
 Message.joins(:user).where(post: Blog.find(5).posts).select("*")
# Obtenga toda la información de los usuarios que son propietarios del primer blog (haz que esto funcione con un simple Blog.first.propietarios).
Blog.first.users 
# Cámbielo, es decir, el primer usuario ya no es propietario del primer blog.
Owner.where("id = ? AND user_id = ?", 1, 1,).update_all("user_id = 5")