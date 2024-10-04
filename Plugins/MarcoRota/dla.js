import fs from "fs/promises";
import path, { join, basename } from "path"; 
import { exec } from "child_process";

const __dirname = path.resolve();
const ytDlpTempDirectory = path.join(process.cwd(), 'src/tmp/YTDLP');
const curlTempDirectory = path.join(process.cwd(), 'src/tmp/CURL');
const maxDownloads = 5; // Instancias Permitidas 
let activeDownloads = 0;
const queue = [];

const cleanCommand = (text) => text.replace(/^\.(dla)\s*/i, "").trim();
const filterArgs = (args, filter) => args.filter(filter);

const processQueue = () => {
  if (activeDownloads >= maxDownloads) {
    
    const { m } = queue[0]; 
    m.reply(`Tu descarga Tardara ya que solo se Permiten ${maxDownloads} Solicitudes Simultaneas. Puedes Cambiar este Valor para Permitir más Instancias.`);
    return;
  }

  if (!queue.length) return; 
  
  const { m, resolve, reject } = queue.shift();
  activeDownloads++;

  handleRequest(m)
    .then(resolve)
    .catch(reject)
    .finally(() => {
      activeDownloads--;
      processQueue(); 
    });
};

let handler = (m) => {
  return new Promise((resolve, reject) => {
    queue.push({ m, resolve, reject }); 
    processQueue(); 
  });
};


const handleRequest = async (m) => {
  const command = cleanCommand(m.text.trim());
  const args = command.split(/\s+/);
  const urls = filterArgs(args, arg => arg.startsWith("http"));

  if (args[0] === 'update') return await updateYtDlp(m);

  if (args[0] === 'curl' && urls.length) {
    const options = filterArgs(args, arg => !arg.startsWith("http") && arg !== 'curl').join(' ');
    await Promise.all(urls.map(url => downloadWithCurl(m, url, options)));
    return;
  }

  if (!urls.length) return await execWithoutUrl(m, args.join(' '));

  const options = filterArgs(args, arg => !arg.startsWith("http")).join(' ');
  await Promise.all(urls.map(url => downloadAndSend(m, url, options)));
};

const execWithoutUrl = async (m, options) => {
  try {
    await m.reply(`⏳ Ejecutando...`);
    const result = await execPromise(`yt-dlp ${options}`);
    await m.reply(`✅ \n${result}`);
  } catch (error) {
    await sendErrorMessage(m, error, `yt-dlp ${options}`);
  }
};

// Función para manejar YT-DLP
const downloadAndSend = async (m, url, options) => {
  let outputFilePathPrefix = join(ytDlpTempDirectory, `download_${Date.now()}`);
  try {
    await prepareDirectory(ytDlpTempDirectory);
    await m.reply(`⏳ Descargando con YT-DLP...`);
    await execPromise(`yt-dlp ${options} --max-filesize 1500M --yes-playlist --abort-on-error -o "${outputFilePathPrefix}_%(title)s.%(ext)s" "${url}"`);

    const downloadedFiles = await findDownloadedFiles(outputFilePathPrefix, ytDlpTempDirectory);
    for (const downloadedFile of downloadedFiles) {
      await sendDownloadedFile(m, join(ytDlpTempDirectory, downloadedFile));
    }
  } catch (error) {
    await sendErrorMessage(m, error, `yt-dlp ${options} -o "${outputFilePathPrefix}_%(title)s.%(ext)s" "${url}"`);
  } finally {
    await cleanupFiles(ytDlpTempDirectory, outputFilePathPrefix);
  }
};

// CURL 
const downloadWithCurl = async (m, url, options) => {
  const fileNameFromUrl = basename(new URL(url).pathname);
  const outputFilePath = join(curlTempDirectory, `download_${Date.now()}_${fileNameFromUrl}`);

  try {
    await prepareDirectory(curlTempDirectory);
    await m.reply(`⏳ Descargando con CURL...`);
    await execPromise(`curl --max-filesize 1500000000 ${options} -o "${outputFilePath}" "${url}"`);
    await fs.access(outputFilePath);
    await sendDownloadedFile(m, outputFilePath);
  } catch (error) {
    await sendErrorMessage(m, error, `curl ${options} -o "${outputFilePath}" "${url}"`);
  } finally {
    await cleanupFiles(curlTempDirectory, outputFilePath);
  }
};

// YT-DLP
const updateYtDlp = async (m) => {
  try {
    await m.reply(`⏳ Actualizando YT-DLP...`);
    await execPromise(`python3 -m pip install -U --pre "yt-dlp[default]"`);
    await m.reply(`✅ YT-DLP actualizado (python3).`);
  } catch (error) {
    try {
      const result = await execPromise(`python -m pip install -U --pre "yt-dlp[default]"`);
      await m.reply(`✅ YT-DLP actualizado (python).\n${result}`);
    } catch (error2) {
      await sendErrorMessage(m, error2, "python -m pip install -U --pre yt-dlp");
    }
  }
};

const execPromise = (command) => {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) reject(stderr || stdout || error);
      else resolve(stdout);
    });
  });
};

const prepareDirectory = async (dir) => {
  await fs.mkdir(dir, { recursive: true });
};

const findDownloadedFiles = async (filePathPrefix, directory) => {
  const files = await fs.readdir(directory);
  return files.filter(file => file.startsWith(path.basename(filePathPrefix)));
};

const sendDownloadedFile = async (m, filePath) => {
  try {
    await fs.stat(filePath);
    await conn.sendMessage(m.chat, {
      document: { url: filePath },
      mimetype: 'application/octet-stream',
      fileName: path.basename(filePath)
    }, { quoted: m });
  } finally {
    await fs.unlink(filePath);
  }
};

const cleanupFiles = async (directory, filePathPrefix) => {
  try {
    const files = await fs.readdir(directory);
    for (const file of files) {
      if (file.startsWith(path.basename(filePathPrefix))) {
        await fs.unlink(join(directory, file));
      }
    }
  } catch (error) {
    console.error("Error al limpiar los archivos:", error);
  }
};

const sendErrorMessage = async (m, error, command) => {
  await m.reply(`❌ \n${error.message || error}\n\nComando ejecutado:\n${command}`);
};

let handler = (m) => {
  return new Promise((resolve, reject) => {
    queue.push({ m, resolve, reject });
    if (activeDownloads < maxDownloads) processQueue();
  });
};

handler.help = ['dla [OPTIONS] URL', 'dla update', 'dla curl [OPTIONS] URL'];
handler.tags = ['tools'];
handler.command = /^(dla)$/i;
handler.owner = false;

export default handler;
