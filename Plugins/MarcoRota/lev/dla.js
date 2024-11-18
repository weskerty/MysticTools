const { bot, isUrl } = require('../lib');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

bot(
  {
    pattern: 'dla ?(.*)',
    fromMe: true,
    desc: 'Download videos using yt-dlp or curl with custom flags, and update yt-dlp',
    type: 'downloader',
  },
  async (message, match) => {
    const args = match.split(/\s+/);
    const command = args[0]; 
    const urls = args.filter((arg) => isUrl(arg)); 
    const options = args.filter((arg) => !isUrl(arg) && arg !== command).join(' '); // Detectar banderas personalizadas
    const tempDir = 'src/tmp/DOWNLOADS/'; // Directorio temporal

    try {
      if (command === 'update') {
        // actualiz ytdlp
        await updateYtDlp(message);
        return;
      }

      if (command === 'curl' && urls.length) {
        //  curl banderas 
        for (const url of urls) {
          await downloadWithCurl(message, url, options, tempDir);
        }
        return;
      }

      if (urls.length) {
        //  yt-dlp con banderas 
        for (const url of urls) {
          await downloadWithYtDlp(message, url, options, tempDir);
        }
      } else {
        await message.send('_Example: dla <url> or dla curl <url> or dla update_');
      }
    } catch (error) {
      // errores send
      await message.send(`❌ Error: ${error.message || error}`);
    }
  }
);

// yt-dlp
async function downloadWithYtDlp(message, url, options, tempDir) {
  const fileName = `download_${Date.now()}`;
  const outputFilePath = path.join(tempDir, `${fileName}.%(ext)s`);

  // crear directorio temporal
  if (!fs.existsSync(tempDir)) {
    fs.mkdirSync(tempDir, { recursive: true });
  }

  // Ejecutar yt-dlp 
  const command = `yt-dlp ${options} --max-filesize 1500M --yes-playlist -o "${outputFilePath}" "${url}"`;
  await executeCommand(command, message);

  // Buscar archivos descargados
  const downloadedFiles = fs
    .readdirSync(tempDir)
    .filter((file) => file.startsWith(fileName));

  if (downloadedFiles.length === 0) {
    throw new Error(`No files were downloaded for URL: ${url}`);
  }

  // Enviar archivos
  for (const file of downloadedFiles) {
    const filePath = path.join(tempDir, file);
    const fileBuffer = fs.readFileSync(filePath);

    await message.send(
      fileBuffer,
      {
        fileName: file,
        mimetype: 'video/mp4',
      },
      'document'
    );

    fs.unlinkSync(filePath); // borrar despues de enviar
  }
}

//  curl
async function downloadWithCurl(message, url, options, tempDir) {
  const fileNameFromUrl = path.basename(new URL(url).pathname);
  const outputFilePath = path.join(tempDir, `curl_${Date.now()}_${fileNameFromUrl}`);

  // crear directorio temporal
  if (!fs.existsSync(tempDir)) {
    fs.mkdirSync(tempDir, { recursive: true });
  }

  // Ejecutar curl 
  const command = `curl --max-filesize 1500000000 ${options} -o "${outputFilePath}" "${url}"`;
  await executeCommand(command, message);

  if (!fs.existsSync(outputFilePath)) {
    throw new Error(`Failed to download file using curl: ${url}`);
  }

  // Enviar el archivo descargado
  const fileBuffer = fs.readFileSync(outputFilePath);

  await message.send(
    fileBuffer,
    {
      fileName: fileNameFromUrl,
      mimetype: 'application/octet-stream',
    },
    'document'
  );

  fs.unlinkSync(outputFilePath); // borrar despues de enviar
}

// actualizar yt-dlp
async function updateYtDlp(message) {
  try {
    await message.send(`⏳ Updating yt-dlp...`);
    const command = `pip install -U "yt-dlp[default]"`;
    await executeCommand(command, message);
    await message.send(`✅ yt-dlp updated.`);
  } catch (error) {
    await message.send(`❌ Failed to update yt-dlp: ${error.message || error}`);
  }
}

// snd error
async function executeCommand(command, message) {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) {
        message.send(`❌ Command failed:\n${stderr || stdout}`);
        reject(stderr || stdout);
      } else {
        resolve(stdout);
      }
    });
  });
}
