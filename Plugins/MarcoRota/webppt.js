import fs from 'fs/promises';
import path, { join, basename } from 'path';
import puppeteer from 'puppeteer';
import fetch from 'node-fetch';

const tempDirectory = path.join(process.cwd(), 'src/tmp/PPT');
const maxDownloads = 2; // Max Solicitudes para Evitar Saturacion del Server.
let activeDownloads = 0;
const queue = [];
let browserInstance = null;

async function initializeBrowser() {
  if (!browserInstance) {
    browserInstance = await puppeteer.launch({
      headless: true,
      args: [
        "--disable-features=BlockInsecurePrivateNetworkRequests",
        "--disable-features=IsolateOrigins", 
        "--disable-site-isolation-trials", 
        '--disable-web-security', 
        "--proxy-server='direct://'", 
        '--proxy-bypass-list=*',
        '--headless',
        '--hide-scrollbars',
        '--mute-audio',
        '--disable-logging',
        '--disable-infobars',
        '--disable-breakpad',
        '--disable-gl-drawing-for-tests',
        '--disable-canvas-aa', // Disable antialiasing on 2d canvas
        '--disable-2d-canvas-clip-aa',
        //'--user-data-dir=/$HOME/.config/chromium/', //ubicacion de los datos. util para que utilice tus credenciales. Riesgoso en caso de que sea plugin publico y agregues credenciales privadas.
        '--no-sandbox' // banderas para probar eficiencia, puedes borrarlas.
      ],
      //executablePath: '/usr/bin/chromium'  // Ruta a Chromium en tu sistema, si no funciona este plugin debes descomentar y agregar la ubicacion de tu instalacion de chomium o firefox. Requerido para Termux o Sistema ARM 
    });
  }
  return browserInstance;
}

async function saveAsMHTML(url) {
  const browser = await initializeBrowser();
  const page = await browser.newPage();
  try {
    await page.goto(url, { timeout: 90000, waitUntil: 'networkidle2' }); // esto es el tiempo limite antes de que falle el intento, actual 1,5m
    const cdp = await page.target().createCDPSession();
    const { data } = await cdp.send('Page.captureSnapshot', { format: 'mhtml' });
    return data;
  } finally {
    await page.close(); 
  }
}

async function saveAsPDF(url) {
  const browser = await initializeBrowser();
  const page = await browser.newPage();
  try {
    await page.goto(url, { timeout: 90000, waitUntil: 'networkidle2' });
    const pdf = await page.pdf({ format: 'A4', printBackground: true });
    return pdf;
  } finally {
    await page.close(); 
  }
}


async function downloadImages(url) {
  const browser = await initializeBrowser();
  const page = await browser.newPage();
  try {
    await page.goto(url, { timeout: 90000, waitUntil: 'networkidle2' });
    const imageUrls = await page.$$eval('img', imgs => 
      imgs.map(img => ({ src: img.src, size: img.naturalWidth * img.naturalHeight }))
    );
    const filteredImages = imageUrls.filter(img => img.size > 10240); // Tamaño Imagen 10KB
    return filteredImages.map(img => img.src);
  } finally {
    await page.close(); 
  }
}

async function handleDownloadRequest(url, conn, m, type = 'mhtml') {
  let fileName = '';
  try {
    const timestamp = Date.now();
    const filePath = join(tempDirectory, `page_${timestamp}.${type}`);

    await fs.mkdir(tempDirectory, { recursive: true });

    let content;
    if (type === 'mhtml') {
      await conn.reply(m.chat, '💾 Descargando...', m);
      content = await saveAsMHTML(url);
    } else if (type === 'pdf') {
      await conn.reply(m.chat, '💾 Generando PDF...', m);
      content = await saveAsPDF(url);
    }

    await fs.writeFile(filePath, content);
    await conn.sendFile(m.chat, filePath, fileName, '❤️', m);

    await fs.unlink(filePath);
  } catch (error) {
    await sendErrorMessage(m, conn, `❌ ${error.message}`);
  } finally {
    activeDownloads--;
    processQueue();
  }
}


async function handleImageDownloadRequest(url, conn, m) {
  try {
    await conn.reply(m.chat, '💾 Descargando Imagenes...', m);
    const imageUrls = await downloadImages(url);

    if (imageUrls.length === 0) {
      await conn.reply(m.chat, '❌ No hay Imagenes mayores a 10KB.', m);
      return;
    }

    for (const imageUrl of imageUrls) {
      const fileName = basename(new URL(imageUrl).pathname);
      const filePath = join(tempDirectory, `image_${Date.now()}_${fileName}`);
      const response = await fetch(imageUrl);
      const buffer = await response.buffer();

      await fs.writeFile(filePath, buffer);
      await conn.sendFile(m.chat, filePath, fileName, '', m);

      await fs.unlink(filePath);
    }
  } catch (error) {
    await sendErrorMessage(m, conn, `❌ ${error.message}`);
  } finally {
    activeDownloads--;
    processQueue(); 
  }
}

async function processQueue() {
  if (queue.length === 0 && activeDownloads === 0) {
    if (browserInstance) {
      try {
        await browserInstance.close();
        browserInstance = null;
        console.log('Navegador cerrado.');
      } catch (err) {
        console.error('Error al cerrar el navegador:', err);
      }
    }
    return;
  }

  if (queue.length > 0 && activeDownloads < maxDownloads) {
    const { url, conn, m, type } = queue.shift(); 
    activeDownloads++;
    if (type === 'img') {
      await handleImageDownloadRequest(url, conn, m);
    } else {
      await handleDownloadRequest(url, conn, m, type);
    }
  }
}

const handler = async (m, { conn, text }) => {
  const args = text.trim().split(/\s+/);
  const url = args.find(arg => arg.startsWith('http'));

  if (!url) {
    await conn.reply(m.chat, '💢 Link', m);
    return;
  }

  const command = args[0];
  let type = 'mhtml';

  if (command === 'pdf') {
    type = 'pdf';
  } else if (command === 'img') {
    type = 'img';
  }

  queue.push({ url, conn, m, type });

  processQueue();
};

const sendErrorMessage = async (m, conn, errorMessage) => {
  await conn.reply(m.chat, errorMessage, m);
};

handler.help = ['web', 'web pdf', 'web img'];
handler.tags = ['tools'];
handler.command = /^(web)$/i;
handler.owner = false;

export default handler;
