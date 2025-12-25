#!/bin/bash
# Bildoptimierungs-Script für Success-Bilder im Hintergrund

echo "🎉 Optimiere Success-Bilder für bessere Performance..."

cd /workspaces/ChristmasPresten2025

# Erstelle success-images Ordner falls nicht vorhanden
mkdir -p success-images

# Backup erstellen
if [ ! -d "success-images-backup" ]; then
    if [ "$(ls -A success-images 2>/dev/null)" ]; then
        echo "📦 Erstelle Backup..."
        cp -r success-images success-images-backup
    fi
fi

# Prüfe verfügbare Tools
if command -v convert &> /dev/null; then
    echo "✅ ImageMagick gefunden"
    
    # Zähle Bilder
    count=0
    for img in success-images/*; do
        if [ -f "$img" ]; then
            ext="${img##*.}"
            ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
            if [[ "$ext_lower" == "jpeg" || "$ext_lower" == "jpg" || "$ext_lower" == "png" || "$ext_lower" == "gif" || "$ext_lower" == "webp" ]]; then
                ((count++))
            fi
        fi
    done
    
    if [ $count -eq 0 ]; then
        echo "ℹ️  Keine Bilder im success-images Ordner gefunden."
        echo "📝 Lege Bilder in den 'success-images' Ordner und führe das Script erneut aus."
        exit 0
    fi
    
    echo "📊 Gefunden: $count Bilder"
    echo ""
    
    for img in success-images/*; do
        if [ -f "$img" ]; then
            ext="${img##*.}"
            ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
            if [[ "$ext_lower" != "jpeg" && "$ext_lower" != "jpg" && "$ext_lower" != "png" && "$ext_lower" != "gif" && "$ext_lower" != "webp" ]]; then
                continue
            fi
            
            filename=$(basename "$img")
            extension="${filename##*.}"
            basename="${filename%.*}"
            
            echo "   📸 Optimiere $filename..."
            
            # Success-Bilder werden im 5x4 Grid angezeigt
            # Bei typischer Auflösung ist jedes Bild etwa 300x200px
            # Wir optimieren auf 400x300px für gute Qualität bei kleiner Dateigröße
            convert "$img" \
                -auto-orient \
                -resize 400x300^ \
                -gravity center \
                -extent 400x300 \
                -quality 75 \
                -strip \
                "/tmp/$basename.jpg"
            
            # Ersetze Original mit optimierter Version
            mv "/tmp/$basename.jpg" "$img"
            
            # Benenne zu .jpg um für Konsistenz (falls es ein PNG war)
            if [ "$extension" != "jpg" ] && [ "$extension" != "jpeg" ]; then
                mv "$img" "success-images/$basename.jpg"
            fi
        fi
    done
    
    echo ""
    echo "✅ Fertig! Alle Bilder optimiert auf 400x300px @ 75% Qualität"
    echo ""
    echo "📊 Vergleich:"
    if [ -d "success-images-backup" ]; then
        echo "   Vorher: $(du -sh success-images-backup/ | cut -f1)"
    fi
    echo "   Nachher: $(du -sh success-images/ | cut -f1)"
    echo ""
    echo "💡 Tipp: Die Bilder sind jetzt optimiert für die Hintergrund-Collage!"
    
elif command -v magick &> /dev/null; then
    echo "✅ ImageMagick (magick) gefunden"
    
    # Zähle Bilder
    count=0
    for img in success-images/*; do
        if [ -f "$img" ]; then
            ext="${img##*.}"
            ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
            if [[ "$ext_lower" == "jpeg" || "$ext_lower" == "jpg" || "$ext_lower" == "png" || "$ext_lower" == "gif" || "$ext_lower" == "webp" ]]; then
                ((count++))
            fi
        fi
    done
    
    if [ $count -eq 0 ]; then
        echo "ℹ️  Keine Bilder im success-images Ordner gefunden."
        echo "📝 Lege Bilder in den 'success-images' Ordner und führe das Script erneut aus."
        exit 0
    fi
    
    echo "📊 Gefunden: $count Bilder"
    echo ""
    
    for img in success-images/*; do
        if [ -f "$img" ]; then
            ext="${img##*.}"
            ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
            if [[ "$ext_lower" != "jpeg" && "$ext_lower" != "jpg" && "$ext_lower" != "png" && "$ext_lower" != "gif" && "$ext_lower" != "webp" ]]; then
                continue
            fi
            
            filename=$(basename "$img")
            extension="${filename##*.}"
            basename="${filename%.*}"
            
            echo "   📸 Optimiere $filename..."
            
            magick "$img" \
                -auto-orient \
                -resize 400x300^ \
                -gravity center \
                -extent 400x300 \
                -quality 75 \
                -strip \
                "/tmp/$basename.jpg"
            
            mv "/tmp/$basename.jpg" "$img"
            
            if [ "$extension" != "jpg" ] && [ "$extension" != "jpeg" ]; then
                mv "$img" "success-images/$basename.jpg"
            fi
        fi
    done
    
    echo ""
    echo "✅ Fertig! Alle Bilder optimiert auf 400x300px @ 75% Qualität"
    echo ""
    echo "📊 Vergleich:"
    if [ -d "success-images-backup" ]; then
        echo "   Vorher: $(du -sh success-images-backup/ | cut -f1)"
    fi
    echo "   Nachher: $(du -sh success-images/ | cut -f1)"
    echo ""
    echo "💡 Tipp: Die Bilder sind jetzt optimiert für die Hintergrund-Collage!"
    
else
    echo "❌ ImageMagick nicht installiert"
    echo "Installation mit: sudo apt-get install imagemagick"
    echo ""
    echo "Alternative: Online-Tools verwenden:"
    echo "  - https://tinypng.com"
    echo "  - https://squoosh.app"
    echo "  - https://imagecompressor.com"
    echo ""
    echo "📝 Empfohlene Einstellungen für Success-Bilder:"
    echo "  - Auflösung: 400x300px"
    echo "  - Qualität: 75%"
    echo "  - Format: JPEG"
    echo "  - Crop: Center (zuschneiden auf exaktes Format)"
fi
