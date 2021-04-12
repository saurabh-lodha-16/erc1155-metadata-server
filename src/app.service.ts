import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getMetadata(id: string): any {
    return data[Number(id) - 1];
  }
}

export const data = [
  {
    name: 'Block A1',
    description:
      'Block A1 are adorable aquatic beings primarily for demonstrating what can be done using the OpenSea platform. Adopt one today to try out all the OpenSea buying, selling, and bidding feature set.',
    image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRofDU5DNb-G_NM6pPHz0T0wN9iCjvc1isEUA&usqp=CAU',
  },
  {
    name: 'Block B1',
    description:
      'Block B1 are adorable aquatic beings primarily for demonstrating what can be done using the OpenSea platform. Adopt one today to try out all the OpenSea buying, selling, and bidding feature set.',
    image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfNnohhyLqDNQmh2JRWSPTHdOgVwbLWVFWqA&usqp=CAU',
  },
  {
    name: 'Block A2',
    description:
      'Block A2 are adorable aquatic beings primarily for demonstrating what can be done using the OpenSea platform. Adopt one today to try out all the OpenSea buying, selling, and bidding feature set.',
    image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRofDU5DNb-G_NM6pPHz0T0wN9iCjvc1isEUA&usqp=CAU',
  },
  {
    name: 'Block B2',
    description:
      'Block B2 are adorable aquatic beings primarily for demonstrating what can be done using the OpenSea platform. Adopt one today to try out all the OpenSea buying, selling, and bidding feature set.',
    image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfNnohhyLqDNQmh2JRWSPTHdOgVwbLWVFWqA&usqp=CAU',
  },
  {
    name: 'Block A1',
    description:
      'Block A1 are adorable aquatic beings primarily for demonstrating what can be done using the OpenSea platform. Adopt one today to try out all the OpenSea buying, selling, and bidding feature set.',
    image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRofDU5DNb-G_NM6pPHz0T0wN9iCjvc1isEUA&usqp=CAU',
  },
  {
    name: 'Block B1',
    description:
      'Block B1 are adorable aquatic beings primarily for demonstrating what can be done using the OpenSea platform. Adopt one today to try out all the OpenSea buying, selling, and bidding feature set.',
    image:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfNnohhyLqDNQmh2JRWSPTHdOgVwbLWVFWqA&usqp=CAU',
  },
];
