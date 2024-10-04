# MysticTools
## Pagina Web de The Mystic Bot y Demas Herramientas.
### Entra a la Pagina Web: https://weskerty.github.io/MysticTools/


# Plugins Extra 
Para agregar tus plugins puedes hacer un fork y luego solicitar un pull con los cambios que hiciste.
Agrega tu Plugin a la Carpeta Plugins/TuNombre/TuPlugin.js
Agrega tus cambios al final de en web/es.html pero antes del </div> final 
#Plantilla para la Web:

```
<blockquote>	
<h1> Titulo  </h1>
<p> Descripcion </p>
<details>
  <summary>🖼️ Demostracion:</summary>
	
<iframe width="90%" height="315" src="https://youtube.com/embed/N8g-R575vJU" title="YouTube video player" allowfullscreen></iframe>
</details>
</br>
</details>
		<details>
           <summary>🗳️ Instalacion</summary>
		  

<blockquote class="red">
<p> Advertencias Opcionales </p>
<p> Advertencias Opcionales </p>
</blockquote>

<h2>🔩 Dependencias </h1>
<p>Instalacion Paquetes del Sistema</p>
<a href="https://wa.me/?text=%24%20choco%20install%20-y%20python%20--override%20--install-arguments%20%27%2Fquiet%20InstallAllUsers%3D1%20PrependPath%3D1%20TargetDir%3DC%3A%5CPython3%27">
  <img src="https://img.shields.io/badge/Windows🔩-0078D6?style=for-the-badge&logo=windows&logoColor=white&style=flat" alt="Reenviar al Bot para Instalar Dependencias a Travez de WhatsApp" height= "30px" loading="lazy"/>
</a>
			.
<a href="https://wa.me/?text=%24%20apt%20install%20python3%20python3-pip%20-y">
  <img src="https://img.shields.io/badge/Linux-Termux-Server🔩-A81D33?style=for-the-badge&logo=debian&logoColor=white&style=flat" height= "30px" loading="lazy"/>
</a>
</br>
			</br>
<p>En Windows, en caso de que no tengas choco eso Fallara. Deberas Instalar <a href="https://www.python.org/downloads/">Python↗️</a> Manualmente y Ajustarlo para Agregarlo a Path e Instalar PIP</p>

		</br>

<p>Listo Explicacion y Proseguir </p>
			</br>

<h2>⬇️ Instalar Dependencia PIP o NPM</h2>			
<a href="https://wa.me/?text=%24%20pip%20install%20-U%20--pre%20%22yt-dlp%5Bdefault%5D%22">
  <img src="https://img.shields.io/badge/InstalacionConPIP-FFD43B?style=for-the-badge&logo=python&logoColor=blue&style=flat" height= "30px" loading="lazy"/>
</a>

</br>
<p>Explicacion y Proseguir con la Instalacion del Plugin</p>

			</br>

<h2>⚙️ Plugin</h2>


<a href="https://wa.me/?text=.plg%20https%3A%2F%2Fraw.githubusercontent.com%2Fweskerty%2FMysticTools%2Frefs%2Fheads%2Fmain%2FPlugins%2FMarcoRota%2Fdla.js">
  <img src="https://img.shields.io/badge/PluginMystic-323330?style=for-the-badge&logo=javascript&logoColor=F7DF1E&style=flat" height= "30px" loading="lazy"/>
</a>

			</br>

<p>Si no Sucedio Ningun error, El Plugin Ahora Debe ser Funcional.</p>

</details></br>

<details>
  <summary>⚒️ Uso:</summary>
<p>Explicacion de Funciones</p>
<p>Funcion para?</p>
<code>comando </code></br>
	
</details>
```

O si no tienes tiempo puedes dejarlo en issues y yo lo agregare cuando tenga tiempo.









#Para usar el Instalador de Plugins del Bot:

El enlace para la instalacion directa desde el boton debe ser el enlace directo a tu plugin RAW, se puede ver ese boton en la Ediccion de GitHub
Ejemplo .ptg https://raw.githubusercontent.com/weskerty/MysticTools/refs/heads/main/Plugins/MarcoRota/groq.js
El Link debe estar codificado en url, puedes hacerlo rapidamente aqui: https://www.urlencoder.org/

##Debe verse asi:

https://wa.me/?text=%24%20npm%20install%20%40sarequl%2Fclient-ip-details%20is-ip%20currency-symbol-map%20country-locale-map%20countryjs%20--no-save%20--force

##Ejemplo Completo:

```
<a href="https://wa.me/?text=%24%20npm%20install%20%40sarequl%2Fclient-ip-details%20is-ip%20currency-symbol-map%20country-locale-map%20countryjs%20--no-save%20--force">
  <img src="https://img.shields.io/badge/1Dependencias🔩-25D366?logo=whatsapp&logoColor=fff&style=flat" alt="Reenviar al Bot para Instalar Plugin a Travez de WhatsApp" height= "30px" loading="lazy"/>
</a>

```

Pueden variar el color, Texto y Estilo, puedes ver mas Aqui: https://github.com/alexandresanlim/Badges4-README.md-Profile/blob/master/README.md

Si tu plugin necesita dependencias/modulos extra agrega --no-save al final para interferir con las actualizaciones del bot.
En caso de que fallen la instalacion de tus modulos extra agrega --force

npm install NombreDePaquete --no-save --force
Plugin del Instalador $ 
Plugin movedor de plugin .plg 

Para agregar video de YT dale compartir y "incrustar"
copia y pegalo para la demostracion de tu plugin

##Ejemplo:

```	
<iframe width="90%" height="315" src="https://youtube.com/embed/1QdI6r7pTZI" title="YouTube video player" allowfullscreen></iframe>
	
```

##Ejemplo Completo:
```
  <summary>🖼️ Demostracion:</summary>
	
<iframe width="90%" height="315" src="https://youtube.com/embed/1QdI6r7pTZI" title="YouTube video player" allowfullscreen></iframe>
	
</details>
```
width="90%" height="315" es el tamaño de ancho y alto en porcentaje y en pixeless 
para un link de short cmbiar short por embed

Mas info aqui:
https://docs.document360.com/docs/embed-youtube-shorts


para agregar un cuadro negro tipo codigo es <code> </code> ya sabes, lo que esta dentro de eso se vera en una linea de codigo.
Para advertencias parpadeantes en rojo es </blockquote> <blockquote> 

Lo que este dentro de "details" sera desplegable
<h3> </h3>
H3 es el tamaño del texto, y </h3> es el cierre del tamaño de texto. Lo que este dentro de <h3> (ejemplo, aqui) </h3> sera de ese Tamaño
</p> Esto es tamaño normal, por parrafo <p>
</br> agregarlo asi hara un salto de Linea.


Emojis Animados, por si quieras Agregarlos a tu Descripcion 
https://telegram-animated-emojis.vercel.app/
Agregar loading="lazy"  para evitar sobrecargar la pagina.
creria se debe agregar loading="lazy" para evitar la carga hasta que se vea, pero desconozco si es hasta llegar a esa seccion o como realmente, no lo probe.
