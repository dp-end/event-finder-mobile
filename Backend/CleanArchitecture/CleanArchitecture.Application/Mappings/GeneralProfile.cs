using AutoMapper;

namespace CleanArchitecture.Core.Mappings // (Veya senin projenin namespace'i, örn: CleanArchitecture.Application.Mappings)
{
    public class GeneralProfile : Profile
    {
        public GeneralProfile()
        {
            // Şablonun eski Ürün (Product) ve Kategori (Category) eşleştirmelerini sildik.
            // İleride kendi modellerimizi (Örn: Event -> EventDto) bağlamak için burayı kullanacağız.
        }
    }
}