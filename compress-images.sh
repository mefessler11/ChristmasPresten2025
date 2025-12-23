#!/bin/bash
# Schnelle Bildkomprimierung für Memory-Spiel

echo "🖼️  Komprimiere Bilder für optimale Performance..."

cd /workspaces/ChristmasPresten2025

# Backup erstellen
if [ ! -d "images-backup" ]; then
    echo "📦 Erstelle Backup..."
    cp -r images images-backup
fi

# Prüfe verfügbare Tools
if command -v convert &> /dev/null; then
    echo "✅ ImageMagick gefunden"
    
    for img in images/*.jpeg images/*.JPG images/*.jpg; do
        if [ -f "$img" ]; then
            filename=$(basename "$img")
            echo "   📸 Optimiere $filename..."
            # Auto-orient ZUERST, dann resize und qualität, dann strip
            convert "$img" -auto-orient -resize 600x600\> -quality 80 -strip "/tmp/$filename"
            mv "/tmp/$filename" "$img"
        fi
    done
    
    echo ""
    echo "✅ Fertig! Vergleiche:"
    du -sh images-backup/ 2>/dev/null || echo "Vorher: unbekannt"
    du -sh images/
    
elif command -v magick &> /dev/null; then
    echo "✅ ImageMagick (magick) gefunden"
    
    for img in images/*.jpeg images/*.JPG images/*.jpg; do
        if [ -f "$img" ]; then
            filename=$(basename "$img")
            echo "   📸 Optimiere $filename..."
            magick "$img" -auto-orient -resize 600x600\> -quality 80 -strip "/tmp/$filename"
            mv "/tmp/$filename" "$img"
        fi
    done
    
    echo ""
    echo "✅ Fertig! Vergleiche:"
    du -sh images-backup/ 2>/dev/null || echo "Vorher: unbekannt"
    du -sh images/
    
else
    echo "❌ ImageMagick nicht gefunden"
    echo "Installation: sudo apt-get update && sudo apt-get install -y imagemagick"
fi
