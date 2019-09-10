/*
 * DynamicElementCreation.ZS:
 * This example shows how to create elements dynamically by displaying a list of
 * the player's weapons. Dynamically-created elements can be used for things like
 * lists, for example.
*/

class Samples_ZF_DynamicElementCreation : Samples_ZF_GenericMenu
{
    // A font to use for text.
    Font smallFont;

    // A background image.
    Samples_ZF_Image background;
    // The labels used for drawing the weapon names
    Array<Samples_ZF_Label> weaponNameLabels;

    override void Init (Menu parent)
    {
        // Call GenericMenu's 'Init' function to do some required initialization.
        Super.Init (parent);
        // Set our base resolution to 320x200.
        SetBaseResolution ((320, 200));

        // Get the smallfont.
        smallFont = Font.GetFont ("SmallFont");

        // Add a background.
        background = new ('Samples_ZF_Image').Init
        (
            // Position.
            (0, 0),
            // Size.
            (320, 200),
            // Image path/name.
            "graphics/ZFormsExamples/Panel.png",
            // Alignment options.
            Samples_ZF_Image.AlignType_TopLeft
        );
        // Add the image element into the main frame.
        background.Pack (mainFrame);
    }

    override void Ticker ()
    {
        // Remove all existing labels from the menu, and delete them.
        while (weaponNameLabels.Size () > 0)
        {
            let label = weaponNameLabels [0];
            weaponNameLabels.Delete (0, 1);

            label.Unpack ();
            label.Destroy ();
        }

        // Sanity checking: Do nothing if there's no consoleplayer
        if (players [consoleplayer].mo == NULL)
        {
            return;
        }

        // Iterate through the player's inventory to find all of their weapons.
        int labelCount = 0; // We need this to calculate the position of the labels.
        let item = players [consoleplayer].mo.inv;
        while (item != NULL)
        {
            // If the inventory item isn't a weapon...
            if (!(item is "Weapon"))
            {
                // Set "item" to the next item in the player's inventory.
                item = item.inv;
                // Continue the loop.
                continue;
            }

            // If there's no space left in the screen...
            if (labelCount > 16)
            {
                // Break out of the loop.
                break;
            }

            // Get the weapon's name.
            let weaponName = item.GetTag ();

            // Add a label.
            let label = new ('Samples_ZF_Label').Init
            (
                // Position.
                (
                    // Horizontal position.
                    14,
                    // Calculate the vertical position.
                    // Initial offset + ((label text height + spacing) * label count)
                    14 + ((smallfont.GetHeight () + 1) * labelCount)
                ),
                // Size.
                (
                    // Calculate the horizontal size of the text.
                    smallfont.StringWidth (weaponName),
                    // Get the font's height.
                    smallFont.GetHeight ()
                ),
                // The label's text.
                text: weaponName,
                // The font to use.
                fnt: smallFont,
                // Whether to automatically wrap the text or not.
                wrap: false,
                // Whether to automatically resize the element based on the text width.
                autoSize: true,
                // The text's colour.
                textColor: Font.CR_WHITE
            );

            // Add the label element to the main frame.
            label.Pack (mainFrame);
            // Add the label to the labels list.
            weaponNameLabels.Push (label);

            // Increment labelCount.
            labelCount++;

            // Set "item" to the next item in the player's inventory.
            item = item.inv;
        }
    }
}
