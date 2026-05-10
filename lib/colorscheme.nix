{ lib }:
{
  mkColorscheme =
    {
      slug,
      palette,
    }:
    {
      inherit
        palette
        slug
        ;
    };
}
