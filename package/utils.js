.pragma library
// 色彩生成工具函数
function hslToHex(h, s, l) {
    h /= 360;
    s /= 100;
    l /= 100;
    
    let r, g, b;
    const hue2rgb = (p, q, t) => {
        if (t < 0) t += 1;
        if (t > 1) t -= 1;
        if (t < 1/6) return p + (q - p) * 6 * t;
        if (t < 1/2) return q;
        if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
        return p;
    };

    const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    const p = 2 * l - q;
    
    r = hue2rgb(p, q, h + 1/3);
    g = hue2rgb(p, q, h);
    b = hue2rgb(p, q, h - 1/3);

    const toHex = x => Math.round(x * 255).toString(16).padStart(2, '0');
    return `#${toHex(r)}${toHex(g)}${toHex(b)}`;
}

// 颜色状态管理
var colorState = { 
    cnt: 0, 
    N: 6,          // 默认色彩阶数
    saturation: 70, // 默认饱和度
    lightness: 65   // 默认亮度
};

// 初始化颜色配置
function initColor(N = 6, saturation = 70, lightness = 65) {
    colorState = {
        cnt: 0,
        N: Math.max(1, N),
        saturation: Math.min(100, Math.max(0, saturation)),
        lightness: Math.min(100, Math.max(0, lightness))
    };
}

// 生成颜色（带自动循环）
function genColor(k, N) {
    const hue = (k * 360 / N) % 360;
    return hslToHex(
        hue, 
        colorState.saturation, 
        colorState.lightness + (k % 2) * 5  // 添加轻微亮度变化提升区分度
    );
}

// 获取下一个颜色
function nextColor() {
    return genColor(colorState.cnt++, colorState.N);
}

function getPercent(percent) {
    return `${(percent * 100).toFixed(2)}%`
}
function getTimeString(secs) {
    const mins = Math.floor((secs / 60) % 60)
    const hours = Math.floor((secs / 3600))
    return (hours ? `${hours}h ` : '') + (mins ? `${mins}min` : '<1min')
}
function toDateTime(secs) {


    /*
    const sec = Math.floor(secs % 60)
    const mins = Math.floor((secs / 60) % 60)
    const hours = Math.floor((secs / 3600))
    const str = `${hours}:${mins}:${sec}`
    return Date.fromLocaleString(Qt.locale(), str, 'hh:mm:ss')*/
    console.warn(Date(secs))
    return Date(secs)
}

function range(start, end, step = 1) {
    const result = [];
    for (let i = start; i < end; i += step) {
      result.push(i);
    }
    return result;
}