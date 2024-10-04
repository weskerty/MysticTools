# MysticTools
Para agregar tus plugins puedes hacer un fork y luego solicitar un pull con los cambios que hiciste.
Agrega tu Plugin a la Carpeta Plugins/TuNombre/TuPlugin.js
Agrega tus cambios al final de en web/es.html pero antes del </div> final 
#Plantilla para la Web:

```
<blockquote>	
<h1>📷 Nombre de tu Plugin</h1>
<p> Este Plugin tiene la Capacidad de... </p>
<details>
  <summary>🖼️ Demostracion:</summary>
  <img src="LINK DIRECTO A IMAGEN" width="70%" height="auto" loading="lazy" />
  <video src="LINK DIRECTO A VIDEO" controls width="100%" height="auto" loading="lazy"></video>
</details>
</br>
<details>
  <summary>🗳️ Instalacion</summary>
  <p>[✅] Plug and play!</p>
<a href="https://wa.me/?text=URLENCODE">
  <img src="https://img.shields.io/badge/💾NOMBREDELBOTON💾-25D366?logo=whatsapp&logoColor=fff&style=flat" alt="Reenviar al Bot para Instalar Plugin a Travez de WhatsApp" height= "30px" loading="lazy"/>
</a>

<h2>👀 Uso</h2>
<code>&lt;prefijo&gt;getfile + &lt;ruta&gt;</code>

<h2>📝 Ejemplo:</h2>
<code>Comandos para su Uso</code>

<details>
  <summary>🛠️ Dependencias Usadas(en caso de que quieras Agregar. Opcional.) </summary>
<a href="https://www.npmjs.com/package/fs">fs</a>
</details>

</blockquote>
</details>
```

O si no tienes tiempo puedes dejarlo en issues y yo lo agregare cuando tenga tiempo.




</br>








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
