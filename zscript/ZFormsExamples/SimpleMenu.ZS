/*
 * SimpleMenu.ZS:
 * This example shows how to make a simple menu with a background, a text label,
 * and a single-texture button.
 * Clicking the button changes the colour of the text label's text to a random
 * colour.
*/

// The menu's command handler.
// This is needed so we can make our menu interactable.
class Samples_SimpleMenuHandler : Samples_ZF_Handler
{
    // The menu this command handler belongs to.
    // We need this to be able to do anything with our menu.
    Samples_ZF_SimpleMenu link;

    override void buttonClickCommand (Samples_ZF_Button caller, string command)
    {
        // If the command is "aButton"...
        if (command == "aButton")
        {
            // Change the text's colour to a random colour.
            link.aLabel.textColor = random [textColor] (Font.CR_BRICK, Font.CR_TEAL);
        }
    }
}

class Samples_ZF_SimpleMenu : Samples_ZF_GenericMenu
{
    // The menu's command handler.
    // We need a command handler so we can make our menu interactable.
    Samples_SimpleMenuHandler handler;

    // A font to use for text.
    Font smallFont;

    // A background image.
    Samples_ZF_Image background;
    // A simple single-texture button.
    Samples_ZF_Button aButton;
    // A text label.
    Samples_ZF_Label aLabel;

    override void Init (Menu parent)
    {
        Vector2 baseRes = (320, 200);

        // Call GenericMenu's 'Init' function to do some required initialization.
        Super.Init (parent);
        // Set our base resolution to 320x200.
        SetBaseResolution (baseRes);

        // Get GZDoom's new options menu smallfont.
        smallFont = OptionFont ();

        // Create an instance of the handler.
        handler = new ('Samples_SimpleMenuHandler');
        // Set the handler's "link" pointer to us.
        handler.link = self;

        // Add a background.
        background = new ('Samples_ZF_Image').Init
        (
            // Position
            (0, 0),
            // Size
            (320, 200),
            // Image path/name
            "graphics/ZFormsExamples/Panel.png",
            // Alignment options
            Samples_ZF_Image.AlignType_TopLeft
        );
        // Add the image element into the main frame.
        background.Pack (mainFrame);

        // Create the box image's textures.
        let boxTexture = Samples_ZF_BoxTextures.CreateTexturePixels
        (
            // The texture itself.
            "graphics/ZFormsExamples/BoxTexture.png",
            // The top-left corner of the middle of the box.
            (32, 32),
            // The bottom-right corner of the middle of the box.
            (64, 64),
            // Whether to scale (true) or tile (false) the sides.
            false,
            // Whether to scale (true) or tile (false) the middle.
            false
        );
        // Add a box image.
        let boxSize = (128, 128);
        let aBoxImage = new ('Samples_ZF_BoxImage').Init
        (
            // Position
            ((baseRes.X - boxSize.X) / 2., (baseRes.Y - boxSize.Y) / 2.),
            // Size
            boxSize,
            // Texture
            boxTexture,
            // Scale
            (0.25, 0.25)
        );
        // Add the box image element into the main frame.
        aBoxImage.Pack (mainFrame);

        // Create the button's textures.
        let buttonIdle = Samples_ZF_BoxTextures.CreateSingleTexture ("graphics/ZFormsExamples/SmallButtonIdle.png", true);
        let buttonHover = Samples_ZF_BoxTextures.CreateSingleTexture ("graphics/ZFormsExamples/SmallButtonHovered.png", false);
        let buttonClick = Samples_ZF_BoxTextures.CreateSingleTexture ("graphics/ZFormsExamples/SmallButtonClicked.png", false);
        // Add a button.
        aButton = new ('Samples_ZF_Button').Init
        (
            // Position
            ((baseRes.X - 18.) / 2., (baseRes.Y - 18.) / 2.),
            // Size
            (18, 18),
            // Our command handler
            cmdHandler: handler,
            // A command string for the button
            command: "aButton",
            // The button's textures
            inactive: buttonIdle,
            hover: buttonHover,
            click: buttonClick
        );
        // Add the button element into the main frame.
        aButton.Pack (mainFrame);

        // Add a label.
        aLabel = new ('Samples_ZF_Label').Init
        (
            // Position
            (0, aButton.box.pos.Y + aButton.box.size.Y + 4),
            // Size.
            (0, smallFont.GetHeight ()),
            // The label's text
            text: "Click me!",
            // The font to use
            fnt: smallFont,
            // Whether to automatically wrap the text or not
            wrap: false,
            // Whether to automatically resize the element based on the text width
            autoSize: true,
            // The text's colour
            textColor: Font.CR_WHITE
        );
        // Calculate the horizontal position for the label so that it's centered on the screen.
        aLabel.box.pos.X = (baseRes.x - smallFont.stringWidth (aLabel.text)) / 2.;
        // Add the label element to the main frame.
        aLabel.Pack (mainFrame);
    }
}
